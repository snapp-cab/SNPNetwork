//
//  UIDevice.swift
//  Driver
//
//  Created by Behdad Keynejad on 9/18/1396 AP.
//  Copyright © 1396 AP Snapp. All rights reserved.
//

import UIKit

extension UIDevice {
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
