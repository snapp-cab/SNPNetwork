//
//  SNPErrorDomain.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/11/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

public struct SNPErrorDomain {
    private static let prefix = "ir.snapp.passenger.error"
    
    static let generic = prefix
    static let authentication = prefix + ".authentication"
    static let network = prefix + ".network"
}
