//
//  SNPNetworkProtocol.swift
//  Alamofire
//
//  Created by farhad jebelli on 8/18/18.
//

import Foundation
import SNPUtilities
import Alamofire

public protocol SNPNetworkProtocol {
    func defaultRequest<T: Decodable, E: SNPError>(url: URLConvertible,
                                            method: HTTPMethod,
                                            parameters: Parameters?,
                                            encoding: ParameterEncoding,
                                            headers: HTTPHeaders?,
                                            appendDefaultHeaders: Bool,
                                            responseKey: String,
                                            completion: @escaping (T?, E?) -> Void)
    func defaultRequest<T: Decodable, E: SNPError>(url: URLConvertible,
                                            method: HTTPMethod,
                                            parameters: Parameters?,
                                            encoding: ParameterEncoding,
                                            headers: HTTPHeaders?,
                                            appendDefaultHeaders: Bool,
                                            responseKey: String,
                                            completion: @escaping ([T]?, E?) -> Void)
    func defaultDownload(_ url: String,
                  progress: ((_ progress: Double) -> Void)?,
                  completion: @escaping (_ result: DownloadResult) -> Void)
}
public extension SNPNetworkProtocol {
    public func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                 method: HTTPMethod = .get,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = URLEncoding.default,
                                                 headers: HTTPHeaders? = nil,
                                                 appendDefaultHeaders: Bool = true,
                                                 responseKey: String = "",
                                                 completion: @escaping (T?, E?) -> Void) {
        defaultRequest(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: completion)
    }
    
    public func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                 method: HTTPMethod = .get,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = URLEncoding.default,
                                                 headers: HTTPHeaders? = nil,
                                                 appendDefaultHeaders: Bool = true,
                                                 responseKey: String = "",
                                                 completion: @escaping ([T]?, E?) -> Void) {
        request(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: completion)
    }
    
    /**
     To download a file.
     
     - Parameter url: url of interest to retrieve data. It should be String
     - Parameter progress: show progress of download.
     - Returns: N/A.
     */
    public func download(_ url: String,
                       progress: ((_ progress: Double) -> Void)?,
                       completion: @escaping (_ result: DownloadResult) -> Void) {
        defaultDownload(url, progress: progress, completion: completion)
    }
}

extension SNPNetworkProtocol {
    public func defaultRequest<T, E>(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, appendDefaultHeaders: Bool, responseKey: String, completion: @escaping (T?, E?) -> Void) where T : Decodable, E : SNPError {
        
    }
    
    public func defaultRequest<T, E>(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, appendDefaultHeaders: Bool, responseKey: String, completion: @escaping ([T]?, E?) -> Void) where T : Decodable, E : SNPError {
        
    }
    
    public func defaultDownload(_ url: String, progress: ((Double) -> Void)?, completion: @escaping (DownloadResult) -> Void) {
        
    }
    
    
}
