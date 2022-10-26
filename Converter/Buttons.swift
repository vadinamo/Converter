//
//  Buttons.swift
//  Converter
//
//  Created by Вадим Юрьев on 26.10.22.
//

import SwiftUI

enum Buttons : String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case dot = "."
    case left = "<"
    case right = ">"
    case swap = "||"
    case copy = "copy"
    case paste = "paste"
    case remove = "<-"
    case clear = "AC"
    
    var buttonColor: Color {
        switch self {
        case .left, .right:
            return Color(UIColor.lightGray)
        case .swap, .copy, .paste, .remove, .clear:
            return .orange
        default:
            return Color(UIColor.darkGray)
        }
    }
}


