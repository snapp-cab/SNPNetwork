//
//  SNPNetworkRequest.swift
//  Alamofire
//
//  Created by Behdad Keynejad on 3/12/1397 AP.
//

import Alamofire
import Foundation
import SNPUtilities

struct SNPNetworkRequest<T: Decodable, E: SNPError> {
    private var alamofireRequest: Alamofire.Request!
    var responseKey: String = ""
    var completion: (T?, E?) -> Void
}
