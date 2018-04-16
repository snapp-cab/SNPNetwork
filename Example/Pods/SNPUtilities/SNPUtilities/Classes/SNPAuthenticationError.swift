//
//  SNPAuthenticationError.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/22/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

public enum SNPAuthenticationError {
    case wrongPhoneNumberFormat
    case emptyPhoneNumber
    case emptyPassword
    case wrongCredentials
    
    var message: String {
        switch self {
        case .wrongPhoneNumberFormat:
            return NSLocalizedString("Wrong phone number format", comment: "Wrong phone number format")
        case .emptyPhoneNumber:
            return NSLocalizedString("Please enter your phone number", comment: "Empty phone number error")
        case .emptyPassword:
            return NSLocalizedString("Please enter your password", comment: "Empty password error")
        case .wrongCredentials:
            return NSLocalizedString("Wrong credentials", comment: "Wrong credentials error")
        }
    }
    
    var code: Int {
        switch self {
        case .wrongPhoneNumberFormat:
            return 1
        case .emptyPhoneNumber:
            return 2
        case .emptyPassword:
            return 3
        case .wrongCredentials:
            return 4
        }
    }
}
