//
//  Persian.swift
//  Pods-SNPUtilities_Example
//
//  Created by farhad jebelli on 7/2/18.
//

import Foundation

extension UInt16 {
    public var toPersian: UInt16 {
        return self - "0".utf16.first! + "۰".utf16.first!
    }
}
extension Character {
    public var toPersian: Character {
        if !("0"..."9" ~= self) {
            return self
        }
        return Character(Unicode.Scalar((self.unicodeScalars.first?.utf16.first)!.toPersian)!)
    }
}

extension String {
    public func convertDigitsFromEnglish(to locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        var formatted = ""
        for char in self {
            if let num = Int("\(char)") {
                formatted.append(formatter.string(for: num)!)
            } else {
                formatted.append(char)
            }
        }
        return formatted
    }
    public mutating func convertedDigitsFromEnglish(to locale: Locale) {
        self = self.convertDigitsFromEnglish(to: locale)
    }
    public func convertDigitsToEnglish() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        var formatted = ""
        for char in self {
            if let num = formatter.number(from: "\(char)") {
                formatted.append("\(num)")
            } else {
                formatted.append(char)
            }
        }
        return formatted
    }
    public mutating func convertedDigitsToEnglish() {
        self = self.convertDigitsToEnglish()
    }
    
    public func commaSeparate(length: Int) -> String {
        if length == 0 {
            return self
        }
        var holder: String = ""
        var start = self.startIndex
        while start < self.endIndex {
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            holder.append(String(self[start..<end]))
            start = end
            if end != self.endIndex {
                holder.append(",")
            }
        }
        return holder
    }
    
    public mutating func commaSeparated(length: Int) {
        self = self.commaSeparate(length: length)
    }
    
    public func convertToPrice(for local:Locale) -> String {
        
        return String(String(self.convertDigitsFromEnglish(to: local).reversed()).commaSeparate(length: 3).reversed())
    }
    public mutating func convertedToPrice(for local: Locale) {
        self = self.convertToPrice(for: local)
    }
    
}
