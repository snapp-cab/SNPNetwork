//
//  URLSessionDataTask.swift
//  SNPUtilities
//
//  Created by Behdad Keynejad on 5/6/1397 AP.
//

import Foundation

extension URLSessionDataTask {
    func httpBodyUTF8() -> String {
        if let data = originalRequest?.httpBody {
            return String(utf8Data: data) ?? ""
        }
        return ""
    }
}
