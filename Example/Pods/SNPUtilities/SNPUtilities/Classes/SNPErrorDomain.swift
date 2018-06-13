//
//  SNPErrorDomain.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/11/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

public struct SNPErrorDomain {
    private static let prefix: String = {
        if Bundle.main.info(for: kCFBundleIdentifierKey! as String) == nil {
            return "test.bundle.error"
        } else {
            return (Bundle.main.info(for: kCFBundleIdentifierKey! as String))! + ".error"
        }
    }()
    
    static let generic = prefix
    static let network = prefix + ".network"
}
