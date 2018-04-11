//
//  SNPErrorDomain.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/11/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

struct SNPErrorDomain {
    private static let prefix = "ir.snapp.driver.error"
    
    static let generic = prefix
    static let authentication = prefix + ".authentication"
    static let network = prefix + ".network"
}
