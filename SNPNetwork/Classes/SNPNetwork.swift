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

public protocol SNPNetworkProtocol {
    func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                            method: HTTPMethod,
                                            parameters: Parameters?,
                                            encoding: ParameterEncoding,
                                            headers: HTTPHeaders?,
                                            appendDefaultHeaders: Bool,
                                            responseKey: String,
                                            completion: @escaping (T?, E?) -> Void)
    func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                            method: HTTPMethod,
                                            parameters: Parameters?,
                                            encoding: ParameterEncoding,
                                            headers: HTTPHeaders?,
                                            appendDefaultHeaders: Bool,
                                            responseKey: String,
                                            completion: @escaping ([T]?, E?) -> Void)
    func download(_ url: String,
                  progress: ((_ progress: Double) -> Void)?,
                  completion: @escaping (_ result: DownloadResult) -> Void)
}

public extension SNPNetworkProtocol {
    func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                            method: HTTPMethod,
                                            parameters: Parameters?,
                                            encoding: ParameterEncoding,
                                            headers: HTTPHeaders?,
                                            appendDefaultHeaders: Bool,
                                            responseKey: String,
                                            completion: @escaping (T?, E?) -> Void) {
        
    }
    func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                            method: HTTPMethod,
                                            parameters: Parameters?,
                                            encoding: ParameterEncoding,
                                            headers: HTTPHeaders?,
                                            appendDefaultHeaders: Bool,
                                            responseKey: String,
                                            completion: @escaping ([T]?, E?) -> Void){
        
    }
    func download(_ url: String,
                  progress: ((_ progress: Double) -> Void)?,
                  completion: @escaping (_ result: DownloadResult) -> Void) {
    }
}

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
     To make request to url.
     
     - Parameter url: url of interest to retrieve data. It should be String
     - Parameter method: is the type of request you look for.
     - Parameter parameters: is a dictionary like this [String: Any]
     - Parameter headers: is a dictionary like this [String: String]
     - Parameter appendDefaultHeaders: is of type Bool. If you set default headers for request, this flag is responsible to append defaultHeader to 'headers' parameter by default, else(appendDefaultHeaders = false)  default headers will be replaced with 'headers' parameter.
     - Parameter responseKey: is expected path of response and will be like "Data.Information.Employee.Person"
     
     - Returns: T, which T is Decodable, and E is kind of SNPError.
     */
    open func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                 method: HTTPMethod = .get,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = URLEncoding.default,
                                                 headers: HTTPHeaders? = nil,
                                                 appendDefaultHeaders: Bool = true,
                                                 responseKey: String = "",
                                                 completion: @escaping (T?, E?) -> Void) {
        request(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: { (result , error: E?) ->  Void in
            guard let dictRes = result?.value as? [String: Any], let result: T = dictRes.toModel(key: responseKey) else {
                completion(nil, error)
                return
            }
            completion(result, error)
        })
    }
    
    open func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                 method: HTTPMethod = .get,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = URLEncoding.default,
                                                 headers: HTTPHeaders? = nil,
                                                 appendDefaultHeaders: Bool = true,
                                                 responseKey: String = "",
                                                 completion: @escaping ([T]?, E?) -> Void) {
        request(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: { (result , error: E?) ->  Void in
            guard let result = result, let arrayRes = result.value as? [Any] else {
                completion(nil, error)
                return
            }
            completion(arrayRes.toModel(key: nil),error)
        })
    }
    
    /**
     To download a file.
     
     - Parameter url: url of interest to retrieve data. It should be String
     - Parameter progress: show progress of download.
     - Returns: N/A.
     */
    open func download(_ url: String,
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
                                      completion: @escaping (SNPDecodable?, E?) -> Void) {
        
        let genericSNPError = SNPError.generic()
        let genericError = E(domain: genericSNPError.domain,
                             code: genericSNPError.code,
                             message: genericSNPError.message)
        let headers: HTTPHeaders? = appendHeaders(shouldAppend: appendDefaultHeaders, headers: headers)
        let alamofireRequest = Alamofire.request(url,
                                                 method: method,
                                                 parameters: parameters,
                                                 encoding: encoding,
                                                 headers: headers)
        
        alamofireRequest.responseData { response in
            if let statusCode = response.response?.statusCode, let jsonData = response.value {
                if statusCode == 401 {
                    // we should start queueing the requests
                    let toBeQueuedRequest = SNPNetworkRequest(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: completion)
                    self.queue.append(toBeQueuedRequest as! SNPNetworkRequest<SNPError>)
                    self.delegate?.refreshAccessToken { error in
                        if error == nil {
                            // successfully refreshed access token
                            // adapt all requests
                            self.queue = self.delegate!.adapt(requests: self.queue)
                            for item in self.queue {
                                self.request(url: item.url, method: item.method, parameters: item.parameters, encoding: item.encoding, headers: item.headers, appendDefaultHeaders: item.appendDefaultHeaders, responseKey: item.responseKey, completion: item.completion)
                                _ = self.queue.remove(at: 0)
                            }
                        } else {
                            // nothing we can do, we must show login page to user
                        }
                    }
                } else if statusCode.isAValidHTTPCode {
                    do {
                        let result = try JSONDecoder().decode(SNPDecodable.self, from: jsonData)
                        completion(result, nil)
                    } catch {
                        // error parsing response to T
                        completion(nil, genericError)
                    }
                } else {
                    do {
                        let error = try JSONDecoder().decode(E.self, from: jsonData)
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
