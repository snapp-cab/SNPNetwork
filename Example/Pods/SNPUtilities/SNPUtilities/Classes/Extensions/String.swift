//
//  String.swift
//  Pods-SNPUtilities_Example
//
//  Created by Behdad Keynejad on 5/2/1397 AP.
//

import Foundation

public extension String {
    public func convertedDigitsFromEnglish(to locale: Locale) -> String {
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
    
    public mutating func convertDigitsFromEnglish(to locale: Locale) {
        self = self.convertedDigitsFromEnglish(to: locale)
    }
    
    public func convertedDigitsToEnglish() -> String {
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
    
    public mutating func convertDigitsToEnglish() {
        self = self.convertedDigitsToEnglish()
    }
    
    public func commaSeparated(length: Int) -> String {
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
    
    public mutating func commaSeparate(length: Int) {
        self = self.commaSeparated(length: length)
    }
    
    public func convertedToPrice(for local:Locale) -> String {
        return String(String(self.convertedDigitsFromEnglish(to: local).reversed()).commaSeparated(length: 3).reversed())
    }
    
    public mutating func convertToPrice(for local: Locale) {
        self = self.convertedToPrice(for: local)
    }
    
    /**
     A shortcut method for printing HTTP response bodies in NSURLSessionDataTask
     - Parameter utf8Data: Data encoded in UTF8 format
     */
    public init?(utf8Data: Data) {
        self.init(data: utf8Data, encoding: .utf8)
    }
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    public func makeCall() {
        if isValid(regex: .phone) {
            if let url = URL(string: "telprompt://\(self)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    public func makeUssdCall() {
        let url = URL(string: "telprompt://\(self)")
        if #available(iOS 10, *) {
            UIApplication.shared.open(url!)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    public func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    public func validatePhoneNumber() -> Bool {
        let regex = "09[0-9]{9}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self.convertedDigitsToEnglish())
    }
    //    public func englishFormat() -> String? {
    //        let Formatter = NumberFormatter()
    //        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
    //        if let final = Formatter.number(from: self) as? String {
    //            return final
    //        }
    //        return nil
    //    }
}
