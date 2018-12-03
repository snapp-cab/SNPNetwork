//
//  SNPError.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/5/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import Foundation

public class SNPError: Error, Decodable {
    // MARK: - Properties
    public private(set) var domain = SNPErrorDomain.generic
    public private(set) var code = -1
    public private(set) var message = ""
    
    // MARK: - Methods
    public required init(domain: String, code: Int = -1, message: String) {
        self.domain = domain
        self.code = code
        self.message = message
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .status)
        let subConstainer = try container.nestedContainer(keyedBy: ErrorCodingKeys.self, forKey: .data)
        message = try subConstainer.decode(String.self, forKey: .message)
        
    }
    
    public func setDomain   (domain: String) {
        self.domain = domain
    }
    
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
    }
    
    enum ErrorCodingKeys: String, CodingKey {
        case message
    }
    
    var isSNPError: Bool {
        return domain.hasPrefix(SNPErrorDomain.generic)
    }
    
    public static func generic() -> SNPError {
        let genericErrorMessage =  NSLocalizedString("Unknown error", comment: "Generic error")
        return SNPError(domain: SNPErrorDomain.generic, code: -1, message: genericErrorMessage)
    }
}
