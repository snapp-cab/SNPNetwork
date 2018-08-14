//
//  SNPNetworkRequest.swift
//  SNPNetwork
//
//  Created by Behdad Keynejad on 23/5/1397 .
//

import Alamofire
import Foundation
import SNPUtilities

public struct SNPNetworkRequest<E: SNPError> {
    public var url: URLConvertible
    public var method: HTTPMethod
    public var parameters: Parameters?
    public var encoding: ParameterEncoding
    public var headers: HTTPHeaders?
    public var responseKey: String
    public var completion: (SNPDecodable?, E?) -> Void
}
