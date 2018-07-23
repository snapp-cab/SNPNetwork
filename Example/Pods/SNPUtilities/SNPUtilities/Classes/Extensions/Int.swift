//
//  Int.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/4/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

extension Int {
    public var isAValidHTTPCode: Bool {
        return (self >= 200 && self <= 299)
    }
}
