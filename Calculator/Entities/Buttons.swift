//
//  Buttons.swift
//  Calculator
//
//  Created by Вадим Юрьев on 21.11.22.
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
    case left = "arrow.left"
    case right = "arrow.right"
    
    case swapKeyboard = "rectangle.2.swap"
    case remove = "delete.left.fill"
    case clear = "trash.slash.fill"
    case calculate = "play.fill"
    
    case plus = "+"
    case minus = "-"
    case multiply = "*"
    case divide = "/"
    
    case sin = "sin"
    case cos = "cos"
    case tg = "tg"
    case ctg = "ctg"
    
    case pow = "^"
    case pi = "pi"
    case exp = "e"
    case lg = "log"
    case ln = "ln"
    case factorial = "!"
    case leftBracket = "("
    case rightBracket = ")"
    
    var buttonColor: Color {
        switch self {
        case .one, .two, .three,
                .four, .five, .six,
                .seven, .eight, .nine,
                .swapKeyboard, .zero, .dot:
            return Color(UIColor.darkGray)
        case .remove, .plus, .minus, .multiply, .divide:
            return .orange
        default:
            return Color(UIColor.lightGray)
        }
    }
    
    var buttonLabel: Text {
        switch self {
        case .left, .right, .swapKeyboard, .remove, .clear, .calculate:
            return Text(Image(systemName: self.rawValue))
        default:
            return Text(self.rawValue)
        }
    }
}
