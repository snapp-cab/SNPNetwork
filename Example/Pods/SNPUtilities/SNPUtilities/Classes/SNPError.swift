//
//  SNPError.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/5/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

public class SNPError: Codable {
    // MARK: - Properties
    public private(set) var domain = SNPErrorDomain.generic
    public private(set) var code = -1
    public private(set) var message = ""
    
    // MARK: - Methods
    required public init(domain: String, code: Int = -1, message: String) {
        self.domain = domain
        self.code = code
        self.message = message
    }
    
    var isSNPError: Bool {
        return domain.hasPrefix(SNPErrorDomain.generic)
    }
    
    public class func generic() -> SNPError {
        let genericErrorMessage =  NSLocalizedString("Unknown error", comment: "Generic error")
        return SNPError(domain: SNPErrorDomain.generic, code: -1, message: genericErrorMessage)
    }
}
