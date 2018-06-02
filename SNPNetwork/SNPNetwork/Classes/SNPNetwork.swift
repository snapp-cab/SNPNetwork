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

public typealias Parameters = Alamofire.Parameters

public class SNPNetwork {
    // MARK: - Properties
    private static var defaultHeaders: HTTPHeaders?
    
    /**
     sets default headers for all requests.
     
     - Parameter headers: desired headers to be set
     
     - Returns: nothing.
     */
    public class func setDefaultHeaders(headers: HTTPHeaders) {
        defaultHeaders = headers
    }
    
    private class func appendHeaders(shouldAppend: Bool, headers: HTTPHeaders?) -> HTTPHeaders? {
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
    
    public static var delegate: SNPNetworkAuthenticationDelegate?
    private static var shouldQueue = false
    private static var queue = [SNPNetworkRequest<<#T: Decodable#>, SNPError>]()
    
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
    public class func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                         method: HTTPMethod = .get,
                                                         parameters: Parameters? = nil,
                                                         encoding: ParameterEncoding = URLEncoding.default,
                                                         headers: HTTPHeaders? = nil,
                                                         appendDefaultHeaders: Bool = true,
                                                         responseKey: String = "",
                                                         completion: @escaping (T?, E?) -> Void) {
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
        
        
        if shouldQueue {
            queue.append(request)
            return
        }
        
        alamofireRequest.responseData { response in
            let snpNetworkResponse = SNPNetworkResponse()
            shouldQueue = delegate?.shouldStartQueueing(networkResponse: response) {
                // always authenticated
                self.shouldQueue = false
                self.queue = self.delegate.updateRequests(self.queue)
                for request in self.queue {
                    request.do()
                }
            }
                
            if shouldQueue {
                self.queue.append(request)
            } else {
                if let statusCode = response.response?.statusCode, let jsonData = response.value {
                    if statusCode.isAValidHTTPCode {
                        do {
                            let resultDic = try JSONDecoder().decode(SNPDecodable.self, from: jsonData).value as! [String: Any]
                            let result: T = resultDic.toModel(key: responseKey)
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
    
    /**
     To download a file.
     
     - Parameter url: url of interest to retrieve data. It should be String
     - Parameter progress: show progress of download.
     - Returns: N/A.
     */
    public class func download(_ url: String,
                               progress: ((_ progress: Double) -> Void)?,
                               completion: @escaping (_ status: String?) -> Void) {
        SNPUtilities.clearTempDirectory()
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.download(url, to: destination)
            .downloadProgress( closure: { prog in
                progress!(prog.fractionCompleted)
            })
            .response(completionHandler: { defaultDownloadResponse in
                if let error = defaultDownloadResponse.error {
                    completion(error.localizedDescription)
                } else {
                    completion("Downloaded file successfully to \(destination)")
                }
            })
    }
}
