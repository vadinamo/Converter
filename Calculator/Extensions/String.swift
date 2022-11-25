//
//  String.swift
//  Calculator
//
//  Created by Вадим Юрьев on 23.11.22.
//

import Foundation

extension String {
    var isNumber: Bool {
        return self.range(
            of: "^[0-9]*$", // 1
            options: .regularExpression) != nil
    }
    
    var isLetter: Bool {
        return self.range(
            of: "^[a-z]*$", // 1
            options: .regularExpression) != nil
    }
    
    var needBracket: Bool {
        return self != "." &&  self != "(" &&  self != ")" &&
        self != "!" && self != "pi" && self != "e" &&
        self != "+" &&  self != "-" &&  self != "*" &&  self != "/"
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

