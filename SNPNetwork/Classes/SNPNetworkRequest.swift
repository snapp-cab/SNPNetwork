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
    var url: URLConvertible
    var method: HTTPMethod
    var parameters: Parameters?
    var encoding: ParameterEncoding
    var headers: HTTPHeaders?
    var responseKey: String
    var completion: (SNPDecodable?, E?) -> Void
}
