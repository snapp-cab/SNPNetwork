//
//  Array.swift
//  Alamofire
//
//  Created by farhad jebelli on 8/8/18.
//

import Foundation

extension Array {
    /**
     Converts dictionary to T, which T is decodable.
     
     - Parameter N/A
     
     - Returns: T, which T is Decodable.
     */
    public func convertToModel<T: Decodable>() -> [T]? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let result = try decoder.decode([T].self, from: jsonData)
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**
     Converts response dictionary to model: T, for given keyPath from caller.
     
     - Parameter dic: response dictionary.
     - Parameter key: given keyPath.
     
     - Returns: T, which is a Decodable model.
     */
    public func toModel<T: Decodable>(key: String?) -> [T] {
        let result: [T] = convertToModel()!
        return result
    }
}
