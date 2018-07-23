//
//  String+ConvertDigits.swift
//  Driver
//
//  Created by Apple on 7/4/17.
//  Copyright © 2017 Snapp. All rights reserved.
//

import Foundation

extension NSString {
    @objc func convertDigitsToEnglishDigits() -> String {
        var characterString = ""
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        var newString = ""
        
        for index in 0..<self.length {
            var character = self.character(at: index)
            characterString = NSString(characters: &character, length: 1) as String
            if let convertedDigit = formatter.number(from: characterString) {
                newString = newString.appending(String(describing: convertedDigit))
            } else {
                newString = newString.appending(String(describing: characterString))
            }
        }
        return newString
    }
}
