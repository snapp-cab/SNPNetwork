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
    
    private static var defaultHeaders: HTTPHeaders?
    
    class func setDefaultHeaders(headers: HTTPHeaders) {
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
    
    public class func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                         method: HTTPMethod = .get,
                                                         parameters: Parameters? = nil,
                                                         encoding: ParameterEncoding = URLEncoding.default,
                                                         headers: HTTPHeaders? = nil,
                                                         appendDefaultHeaders: Bool = true,
                                                         responseKey: String? = nil,
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
        
        alamofireRequest.responseData { response in
            if let statusCode = response.response?.statusCode, let jsonData = response.value {
                if statusCode.isAValidHTTPCode {
                    do {
                        let resultDic = try JSONDecoder().decode(SNPDecodable.self,
                                                                 from: jsonData).value as! [String: Any]
                        if responseKey == nil {
                            let result = resultDic as? T
                            completion(result, nil)
                        } else {
                            let result: T = resultDic.toModel(key: responseKey)
                            completion(result, nil)
                        }
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
    
    public class func download(_ url: String,
                               progress: ((_ progress: Double) -> Void)?,
                               completion: @escaping (_ status: String?) -> Void) {
        Utilities.clearTempDirectory()
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
