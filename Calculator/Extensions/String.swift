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
    var needBracket: Bool {
        return self != "." &&  self != "(" &&  self != ")" &&
        self != "!" && self != "pi" && self != "e" &&
        self != "+" &&  self != "-" &&  self != "*" &&  self != "/"
    }
}
