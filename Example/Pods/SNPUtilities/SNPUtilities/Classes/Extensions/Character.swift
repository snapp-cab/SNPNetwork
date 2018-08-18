//
//  Character.swift
//  Pods-SNPUtilities_Example
//
//  Created by Behdad Keynejad on 5/2/1397 AP.
//

import Foundation

extension Character {
    public var toPersian: Character {
        if !("0"..."9" ~= self) {
            return self
        }
        return Character(Unicode.Scalar((self.unicodeScalars.first?.utf16.first)!.toPersian)!)
    }
}
