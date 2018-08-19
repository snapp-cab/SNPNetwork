
//
//  SNPDecoder.swift
//  Pods-SNPUtilities_Example
//
//  Created by farhad jebelli on 8/18/18.
//

import Foundation

enum SNPDecoderError: Error {
    case nilError(error: String)
}

public class SNPDecoder <T: Decodable> {
    private var value: T?
    private var array: [T]?
    private let path: String?
    private let decoder: DecoderContainer
    public init(type: T.Type,data: Data,codingPath: String?) throws {
        decoder = try! JSONDecoder().decode(DecoderContainer.self, from: data)
        self.path = codingPath
        
    }
    
    public func decode() throws ->  T? {
        try extractPath(container: decoder.decoder)
        return value
    }
    
    public func decodeArray() throws ->  [T]? {
        try extractPath(container: decoder.decoder)
        return array
    }
    
    private func decode(single: SingleValueDecodingContainer?, unkeyed: UnkeyedDecodingContainer?, keyed: KeyedDecodingContainer<CodingKeys>?, codingKey: CodingKeys?) throws {
        var codingKey = codingKey
        guard codingKey != nil else {
            if single != nil {
                value = try single?.decode(T.self)
            } else if unkeyed != nil {
                try decodeUnkeyed(unkeyed: unkeyed!, codingKey: nil)
            }
            return
        }
        
        var unkeyed = unkeyed
        if keyed != nil {
            let innerUnkeyed:UnkeyedDecodingContainer?
            do {
                innerUnkeyed =  try keyed?.nestedUnkeyedContainer(forKey: codingKey!)
            } catch {
                innerUnkeyed = nil
            }
            if innerUnkeyed != nil  {
                unkeyed = innerUnkeyed
                codingKey = nil
            } else {
                value = try keyed?.decode(T.self, forKey: codingKey!)
                return
            }
        }
        
        if value == nil && unkeyed != nil {
            try decodeUnkeyed(unkeyed: unkeyed!, codingKey: codingKey)
        } else {
            throw SNPDecoderError.nilError(error: "can not parse value")
        }
    }
    
    private func decodeUnkeyed(unkeyed: UnkeyedDecodingContainer, codingKey: CodingKeys?) throws {
        array = []
        var unkeyed = unkeyed
        var i = 0
        while !unkeyed.isAtEnd {
            if let index = codingKey?.intValue{
                if i == index {
                    let innerUnkeyed: UnkeyedDecodingContainer
                    do {
                        innerUnkeyed = try unkeyed.nestedUnkeyedContainer()
                        try decodeUnkeyed(unkeyed: innerUnkeyed, codingKey: nil)
                    } catch {
                        value = try unkeyed.decode(T.self)
                    }
                    return
                }
                _ = try unkeyed.superDecoder()
                i += 1
            } else {
                try array?.append(unkeyed.decode(T.self))
            }
        }
    }
    
    private func extractPath(container: Decoder) throws {
        var codingKeyPath = self.path?.components(separatedBy: ".").filter({!$0.isEmpty}).map({ (str: String) -> CodingKeys in
            if let index = Int(string: str) {
                return CodingKeys(intValue: index)!
            } else {
                return CodingKeys(stringValue: str)!
            }
        })
        if codingKeyPath?.count ?? 0 == 0 {
            let single: SingleValueDecodingContainer?
            let unkeyed: UnkeyedDecodingContainer?
            
            do {
                single = try container.singleValueContainer()
                
            } catch {
                single = nil
            }
            do {
                unkeyed = try container.unkeyedContainer()
            } catch {
                unkeyed = nil
            }
            if unkeyed != nil {
                try decode(single: nil, unkeyed: unkeyed, keyed: nil, codingKey: nil)
            } else if single != nil {
                try decode(single: single, unkeyed: nil, keyed: nil, codingKey: nil)
            } else {
                throw SNPDecoderError.nilError(error: "both containers are nil")
            }
            return
        }
        var keyed: KeyedDecodingContainer<CodingKeys>? = try? container.container(keyedBy: CodingKeys.self)
        var unkeyed: UnkeyedDecodingContainer? = try? container.unkeyedContainer()
        let last = codingKeyPath?.popLast()
        for key in codingKeyPath ?? [] {
            guard keyed != nil || unkeyed != nil else {
                throw SNPDecoderError.nilError(error: "keyed and unkeyed are both nil")
            }
            if let index = key.intValue {
                do {
                    unkeyed = try iterateToIndex(unkeyed: unkeyed, index: index)
                }catch {}
                do {
                    keyed = try iterateToIndex(unkeyed: unkeyed, index: index)
                } catch {}
            } else {
                do {
                    keyed = try keyed?.nestedContainer(keyedBy: CodingKeys.self, forKey: key)
                } catch {

                }
                do {
                    unkeyed = try keyed?.nestedUnkeyedContainer(forKey: key)
                    keyed = nil
                } catch {
                    
                }
            }
        }
        if keyed != nil {
            try decode(single: nil, unkeyed: nil, keyed: keyed, codingKey: last)
        } else if unkeyed != nil {
            try decode(single: nil, unkeyed: unkeyed, keyed: nil, codingKey: last)
        }
    }
    
    private func iterateToIndex(unkeyed: UnkeyedDecodingContainer?, index: Int) throws -> UnkeyedDecodingContainer? {
        guard var unkeyed = unkeyed else {
            throw SNPDecoderError.nilError(error: "unkeyed in nil")
        }
        
        for _ in (0..<index) {
            _ = try unkeyed.superDecoder()
        }
        return try unkeyed.nestedUnkeyedContainer()
    }
    
    private func iterateToIndex(unkeyed: UnkeyedDecodingContainer?, index: Int) throws -> KeyedDecodingContainer<CodingKeys>? {
        var unkeyed = unkeyed
        for _ in (0..<index) {
            _ = try unkeyed?.superDecoder()
        }
        return try unkeyed?.nestedContainer(keyedBy: CodingKeys.self)
    }
    
}
private struct CodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}
private struct DecoderContainer: Decodable {
    let decoder: Decoder
    init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
}


