//
//  Bundle.swift
//  SNPUtilities
//
//  Created by Behdad Keynejad on 3/22/1397 AP.
//

import Foundation

extension Bundle {
    public func load<T>(_ nibName: String = String(describing: T.self)) -> T {
        return loadNibNamed(nibName, owner: nil, options: nil)?.first as! T
    }
    
    public func info(for key: String) -> String! {
        guard let value = infoDictionary?[key] else {
            return nil
        }
        return (value as! String).replacingOccurrences(of: "\\", with: "")
    }
    
    public func read(fileName: String, type: String) -> String? {
        if let path = self.path(forResource: fileName, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return String(data: data, encoding: .utf8)
            } catch {
                return nil
            }
        }
        return nil
    }
}
