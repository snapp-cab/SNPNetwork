//
//  UInt16.swift
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
