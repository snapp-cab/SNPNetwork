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
    
    public var c_type_bool: Bool {
            return self == 0 ? false : true
    }
    
    public init?(string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string)
        
    }
    
}
