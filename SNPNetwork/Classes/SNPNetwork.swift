//
//  SNPAlamofireObjectMapper.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/4/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation
import Alamofire
import SNPUtilities

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias JSONEncoding = Alamofire.JSONEncoding
public typealias URLEncoding = Alamofire.URLEncoding

public enum DownloadResult {
    case success(String)
    case failure(String?)
    
    func get() -> String? {
        switch self {
        case .success(let result):
            return result
        case .failure(let result):
            return result
        }
    }
}
public typealias Parameters = Alamofire.Parameters


open class SNPNetwork: SNPNetworkProtocol {
    // MARK: Properties
    open static let shared = SNPNetwork()
    private var defaultHeaders: HTTPHeaders?
    private var queue = [SNPNetworkRequest]()
    private var mustQueue = false
    open var delegate: SNPAuthenticationDelegate?
    /**
     sets default headers for all requests.
     
     - Parameter headers: desired headers to be set
     
     - Returns: nothing.
     */
    open func setDefaultHeaders(headers: HTTPHeaders) {
        defaultHeaders = headers
    }
    
    open func appendHeaders(shouldAppend: Bool, headers: HTTPHeaders?) -> HTTPHeaders? {
        if shouldAppend == false {
            //just replace input headers with defaultHeaders
            defaultHeaders = headers
            return headers
        } else {
            //append input headers with defaultHeaders
            if headers != nil {
                let header: HTTPHeaders! = headers!
                return header?.merge(with: defaultHeaders!)
            } else {
                return defaultHeaders
            }
        }
    }
    
    /**
     To make reqeut to url.
     
     - Parameter url: url of interest to retrieve data. It should be String
     - Parameter method: is the type of request you look for.
     - Parameter parameters: is a dictionary like this [String: Any]
     - Parameter headers: is a dictionary like this [String: String]
     - Parameter appendDefaultHeaders: is of type Bool. If you set default headers for request, this flag is responsible to append defaultHeader to 'headers' parameter by default, else(appendDefaultHeaders = false)  default headers will be replaced with 'headers' parameter.
     - Parameter responseKey: is expected path of response and will be like "Data.Information.Employee.Person"
     
     - Returns: T, which T is Decodable, and E is kind of SNPError.
     */
    open func defaultRequest<T: Decodable, E: SNPError>(url: URLConvertible,
                                                 method: HTTPMethod = .get,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = URLEncoding.default,
                                                 headers: HTTPHeaders? = nil,
                                                 appendDefaultHeaders: Bool = true,
                                                 responseKey: String = "",
                                                 completion: @escaping (T?, E?) -> Void) {
        request(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: { (data , error: E?) ->  Void in
            let genericError = E(domain: (try? url.asURL().absoluteString) ?? "",
                                 code: -10,
                                 message: "")
            do {
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                let decodable = try SNPDecoder(type: T.self, data: data, codingPath: responseKey).decode()
                completion(decodable, nil)
            } catch {
                completion(nil, E(domain: genericError.domain, code: genericError.code, message: error.localizedDescription)) }
        })
    }
    
    open func defaultRequest<T: Decodable, E: SNPError>(url: URLConvertible,
                                                 method: HTTPMethod = .get,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = URLEncoding.default,
                                                 headers: HTTPHeaders? = nil,
                                                 appendDefaultHeaders: Bool = true,
                                                 responseKey: String = "",
                                                 completion: @escaping ([T]?, E?) -> Void) {
        request(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: { (data , error: E?) ->  Void in
            let genericError = E(domain: (try? url.asURL().absoluteString) ?? "",
                                 code: -10,
                                 message: "")
            do {
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                let decodable = try SNPDecoder(type: T.self, data: data, codingPath: responseKey).decodeArray()
                completion(decodable, nil)
            } catch {
                completion(nil, E(domain: genericError.domain, code: genericError.code, message: error.localizedDescription)) }
            
        })
    }
    
    /**
     To download a file.
     
     - Parameter url: url of interest to retrieve data. It should be String
     - Parameter progress: show progress of download.
     - Returns: N/A.
     */
    open func defaultDownload(_ url: String,
                       progress: ((_ progress: Double) -> Void)?,
                       completion: @escaping (_ result: DownloadResult) -> Void) {
        SNPUtilities.clearTempDirectory()
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download(url, to: destination)
            .downloadProgress( closure: { prog in
                progress!(prog.fractionCompleted)
            })
            .response(completionHandler: { defaultDownloadResponse in
                if let error = defaultDownloadResponse.error {
                    completion(.failure(error.localizedDescription))
                } else {
                    completion(.success("Downloaded file successfully to \(destination)"))
                }
            })
    }
    
    // MARK: Private functions
    private func request<E: SNPError>(url: URLConvertible,
                                                 method: HTTPMethod = .get,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = URLEncoding.default,
                                                 headers: HTTPHeaders? = nil,
                                                 appendDefaultHeaders: Bool = true,
                                                 responseKey: String = "",
                                                 completion: @escaping (Data?, E?) -> Void) {
        if mustQueue == true {
            let toBeQueuedRequest = SNPNetworkRequest(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: completion)
            self.queue.append(toBeQueuedRequest as! SNPNetworkRequest<SNPError>)
            return
        }
        let genericSNPError = SNPError.generic()
        let genericError = E(domain: genericSNPError.domain,
                             code: genericSNPError.code,
                             message: genericSNPError.message)
        let header: HTTPHeaders? = appendHeaders(shouldAppend: appendDefaultHeaders, headers: headers)
        let alamofireRequest = Alamofire.request(url,
                                                 method: method,
                                                 parameters: parameters,
                                                 encoding: encoding,
                                                 headers: header)
        
        alamofireRequest.responseData { response in
            if let statusCode = response.response?.statusCode, let jsonData = response.value {
                if statusCode == 401 {
                    // we should start queueing the requests
                    let toBeQueuedRequest = SNPNetworkRequest(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: completion)
                    self.queue.append(toBeQueuedRequest as! SNPNetworkRequest<SNPError>)
                    self.mustQueue = true
                    self.delegate?.refreshAccessToken { error in
                        if error == nil {
                            // successfully refreshed access token
                            // adapt all requests
                            self.queue = self.delegate!.adapt(requests: self.queue)
                            // turn `mustQueue` flag off, because we have new valid access token and no longer need to enqueue requests.
                            self.mustQueue = false
                            // now dequeue each request and make it call again.
                            for item in self.queue {
                                self.request(url: item.url, method: item.method, parameters: item.parameters, encoding: item.encoding, headers: item.headers, appendDefaultHeaders: item.appendDefaultHeaders, responseKey: item.responseKey, completion: item.completion)
                                _ = self.queue.remove(at: 0)
                            }
                        } else {
                            self.queue.map({$0.completion}).forEach { $0(nil, SNPError.generic()) }
                            self.queue = []
                            self.mustQueue = false
                        }
                    }
                } else if statusCode.isAValidHTTPCode {
                    completion(jsonData, nil)
                } else {
                    do {
                        let error = try SNPDecoder(type: E.self, data: jsonData, codingPath: nil).decode()
                        completion(nil, error)
                    } catch {
                        // error parsing response to E
                        completion(nil, genericError)
                    }
                }
            } else {
                // unknown network error
                completion(nil, genericError)
            }
        }
        
    }
}
