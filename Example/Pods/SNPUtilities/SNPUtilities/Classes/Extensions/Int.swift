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
    
    public func convertToEquivalenceMonthName() -> String {
        switch self {
        case 0:
            return NSLocalizedString("January", comment: "")
        case 1:
            return NSLocalizedString("February", comment: "")
        case 2:
            return NSLocalizedString("March", comment: "")
        case 3:
            return NSLocalizedString("April", comment: "")
        case 4:
            return NSLocalizedString("May", comment: "")
        case 5:
            return NSLocalizedString("June", comment: "")
        case 6:
            return NSLocalizedString("July", comment: "")
        case 7:
            return NSLocalizedString("August", comment: "")
        case 8:
            return NSLocalizedString("September", comment: "")
        case 9:
            return NSLocalizedString("October", comment: "")
        case 10:
            return NSLocalizedString("November", comment: "")
        case 11:
            return NSLocalizedString("December", comment: "")
        default:
            return "\(self)"
        }
    }
}
