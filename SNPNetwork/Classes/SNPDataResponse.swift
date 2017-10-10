//
//  SNPDataResponse.swift
//  Alamofire
//
//  Created by Nader Rashed on 10/4/17.
//

import Alamofire

public enum SNPNetworkResult<Value> {
    case success(Value)
    case failure(Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
    
    public init(alamofireEnum:Result<Value>){
        switch alamofireEnum {
        case .success(let value):
            self = .success(value)
        case .failure(let error):
            self = .failure(error)
        default: break
        }
        
    }
}


/// Used to store all data associated with a serialized response of a data or upload request.
public struct SNPDataResponse<value>{
    /// The URL request sent to the server.
    public let request: URLRequest?
    
    /// The server's response to the URL request.
    public let response: HTTPURLResponse?
    
    /// The data returned by the server.
    public let data: Data?
    
    public var value: value? { return result.value }

    public let result:SNPNetworkResult<value>


    var _metrics: AnyObject?
    
    /// - parameter request:  The URL request sent to the server.
    /// - parameter response: The server's response to the URL request.
    /// - parameter data:     The data returned by the server.
    /// - parameter result:   The result of response serialization.
    /// - parameter timeline: The timeline of the complete lifecycle of the `Request`. Defaults to `Timeline()`.
    ///
    /// - returns: The new `DataResponse` instance.
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: SNPNetworkResult<value>)
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
}

