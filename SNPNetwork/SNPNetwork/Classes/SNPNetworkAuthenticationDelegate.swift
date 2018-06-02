//
//  SNPNetworkAuthenticationDelegate.swift
//  Alamofire
//
//  Created by Behdad Keynejad on 3/12/1397 AP.
//

import Foundation
import SNPUtilities

public protocol SNPNetworkAuthenticationDelegate {
    associatedtype T = Decodable
    associatedtype E = SNPError
    func shouldStartQueueing(networkResponse: SNPNetworkResponse, completion: ()) -> Bool
    func updateRequests(requests: [SNPNetworkRequest<T, E>]) -> [SNPNetworkRequest<T, E>]
}
