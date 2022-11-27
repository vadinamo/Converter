//
//  Operations.swift
//  Calculator
//
//  Created by Вадим Юрьев on 23.11.22.
//

import Foundation
import _NumericsShims
import BigDecimal


var several_items_operations: [String] = [
    "+",
    "-",
    "*",
    "/",
    "^"
]

var single_items_operations: [String] = [
    "sin",
    "cos",
    "tg",
    "ctg",
    "ln",
    "log",
    "!",
    "e",
    "pi"
]

var priority: [String: Int] = [
    "(": 0,
    ")": 0,
    "+": 1,
    "-": 1,
    "*": 2,
    "/": 2,
    "^": 3,
    "sin": 4,
    "cos": 4,
    "tg": 4,
    "ctg": 4,
    "ln": 4,
    "log": 4,
    "!": 4
]

func makeOperation(number1: BigDecimal, number2: BigDecimal, symbol: String) throws -> BigDecimal {
    let n1: Double = btd(number: number1)
    let n2: Double = btd(number: number2)
    switch symbol {
    case "+":
        return number1 + number2
    case "-":
        return number2 - number1
    case "*":
        return number1 * number2
    case "/":
        if number1 == 0 {
            throw CalculateErrors.DivisionByZero
        }
        return number2 / number1
    case "^":
        return BigDecimal(floatLiteral: libm_pow(n2, n1))
    case "sin":
        return BigDecimal(floatLiteral: libm_sin(n1))
    case "cos":
        return BigDecimal(floatLiteral: libm_cos(n1))
    case "tg":
        return BigDecimal(floatLiteral: libm_tan(n1))
    case "ctg":
        return BigDecimal(floatLiteral: 1 / libm_tan(n1))
    case "!":
        if number1 > 150 {
            throw CalculateErrors.InvalidArgument
        }
        return BigDecimal(floatLiteral: factorial(Int(n1)))
    case "ln":
        return BigDecimal(floatLiteral: libm_log(n1))
    case "log":
        return BigDecimal(floatLiteral: libm_log10(n1))
    case "e":
        return BigDecimal(floatLiteral: exp(1))
    case "pi":
        return 3.141592653589793
    default:
        return 0
    }
}

func factorial(_ n: Int) -> Double {
  return (1...n).map(Double.init).reduce(1.0, *)
}

func btd(number: BigDecimal) -> Double {
    return Double(String(number))!
}

enum CalculateErrors: Error {
    case InvalidArgument
    case DivisionByZero
}
