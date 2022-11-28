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
    "!": 4,
    "e": 4
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
        if String(libm_pow(n2, n1)) == "inf" {
            throw CalculateErrors.Overload
        }
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
        if number1 > 10000 {
            throw CalculateErrors.Overload
        }
        return factorial(number1)
    case "ln":
        return BigDecimal(floatLiteral: libm_log(n1))
    case "log":
        return BigDecimal(floatLiteral: libm_log10(n1))
    case "e":
        return exp(num: number1)
    case "pi":
        return 3.141592653589793
    default:
        return 0
    }
}

func factorial(_ n: BigDecimal) -> BigDecimal {
    var r: BigDecimal = 1
    if n < 2 {
        return r
    }
    
    for i in 2...Int(n) {
        r *= BigDecimal(i)
    }
    
    return r
}


func int_pow(value: BigDecimal, power: Int) -> BigDecimal {
    var v = value
    var p: Int = power
    
    var result: BigDecimal = 1
    while p > 0{
        if p % 2 == 1{
            result *= v
        }
        v *= v
        p = p / 2
    }
    
    return result
}


func exp(num: BigDecimal) -> BigDecimal {
    var prev: BigDecimal = 0
    var curr:  BigDecimal = 1
    var i: BigDecimal = 1
    
    while abs(curr - prev) > 0.0000000000000000000000000001 {
        prev = curr
        curr += int_pow(value: num, power: Int(i)) / factorial(i)
        
        i += 1
    }
    
    return curr
}


func btd(number: BigDecimal) -> Double {
    return Double(String(number))!
}

enum CalculateErrors: Error {
    case InvalidArgument
    case DivisionByZero
    case Overload
}
