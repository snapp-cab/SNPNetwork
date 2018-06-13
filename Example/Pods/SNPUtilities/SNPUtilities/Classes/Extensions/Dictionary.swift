//
//  File.swift
//  Driver
//
//  Created by Arash Z.Jahangiri on 1/21/18.
//  Copyright © 2018 Snapp. All rights reserved.
//

import Foundation

extension Dictionary {
    /**
     Converts dictionary to T, which T is decodable.
     
     - Parameter N/A
     
     - Returns: T, which T is Decodable.
     */
    func convertToModel<T: Decodable>() -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: jsonData)
            return result
        } catch {
            print(error.localizedDescription)
            return SNPError(domain: "convertingJson", code: 999, message: error.localizedDescription) as? T
        }
    }
    
    /**
     Converts response dictionary to model: T, for given keyPath from caller.
     
     - Parameter dic: response dictionary.
     - Parameter key: given keyPath.
     
     - Returns: T, which is a Decodable model.
     */
    func toModel<T: Decodable>(key: String?) -> T {
        let array = key?.components(separatedBy: ".")
        let finalDic = getValue(forKeyPath: array!)
        let result: T = finalDic.convertToModel()!
        return result
    }
    
    /**
     Merge and return a new dictionary.
     
     - Parameter with: is dictionary.
     
     - Returns: dictionary.
     */
    func merge(with: [Key: Value]?) -> [Key: Value]? {
        var copy = self
        for (key, val) in with! {
            // If a key is already present it will be overritten
            copy[key] = val
        }
        return copy
    }
}

extension Dictionary where Key: Any, Value: Any {
    /**
     Returns a dictionary for a given KeyPath in a recursive manner.
     
     - Parameter components: Nested Keys as an Array.
     
     - Returns: A dictionary.
     */
    func getValue(forKeyPath components: [Any]) -> [String: AnyObject] {
        var comps = components
        let key = comps.remove(at: 0)
        if let aKey = key as? Key {
            if aKey is String && (aKey as! String) == "" {
                return self as! [String: AnyObject]
            }
            if comps.count == 0 {
                return self[aKey] as! [String: AnyObject]
            }
            if let value = self[aKey] as? [String: AnyObject] {
                return value.getValue(forKeyPath: comps)
            }
        }
        return [:]
    }
}
