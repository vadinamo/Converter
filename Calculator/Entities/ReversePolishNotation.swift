//
//  ReversePolishNotation.swift
//  Calculator
//
//  Created by Вадим Юрьев on 25.11.22.
//

import _NumericsShims
import Foundation


func completeBrackets(string: String) -> String {
    var edited = string
    var stack: [String] = []
    for s in edited {
        if s == "(" {
            stack.append("(")
        }
        else if s == ")" {
            stack.removeLast()
        }
    }
    
    if (stack.count != 0) {
        for _ in stack {
            edited += ")"
        }
    }
    
    return edited
}

func completeNegative(string: String) -> String {
    var edited = string
    
    for i in 0..<edited.count {
        if edited[i] == "-" && (i == 0 || several_items_operations.contains(where: {$0 == edited[i - 1]}) || edited[i - 1] == "(") {
            let start = edited.prefix(i)
            let end = edited.suffix(edited.count - i)
            edited = start + "0" + end
        }
    }
    
    return edited
}

func completeString(string: String) -> String {
    return completeNegative(string: completeBrackets(string: string))
}

func factorial(_ n: Int) -> Double {
  return (1...n).map(Double.init).reduce(1.0, *)
}

func makeOperation(number1: Double, number2: Double, symbol: String) -> Double {
    switch symbol {
    case "+":
        return number1 + number2
    case "-":
        return number2 - number1
    case "*":
        return number1 * number2
    case "/":
        return number2 / number1
    case "^":
        return libm_pow(number2, number1)
    case "sin":
        return libm_sin(number1)
    case "cos":
        return libm_cos(number1)
    case "tg":
        return libm_tan(number1)
    case "ctg":
        return 1 / libm_tan(number1)
    case "!":
        return factorial(Int(number1))
    case "ln":
        return libm_log(number1)
    case "log":
        return libm_log10(number1)
    case "e":
        return exp(1)
    case "pi":
        return 3.141592653589793
    default:
        return 0
    }
}

func rpn(input: String) -> [String] {
    var inputStr = completeString(string: input).replacingOccurrences(of: "pi", with: "3.141592653589793").replacingOccurrences(of: "e", with: "2.71828")
    
    var stack: [String] = []
    var number = ""
    var operation = ""
    
    var output: [String] = []
    let letters = CharacterSet.letters
    for i in 0..<inputStr.count {
        if inputStr[i].isLetter || inputStr[i] == "!" {
            operation += inputStr[i]
        }
        if inputStr[i].isNumber || inputStr[i] == "." {
            number += inputStr[i]
        }
        else if priority.keys.contains(where: {$0 == inputStr[i]}) || priority.keys.contains(where: {$0 == operation}) {
            if number.count != 0 {
                output.append(number)
                number = ""
            }
            
            if inputStr[i] == "(" {
                stack.append(inputStr[i])
            }
            else if inputStr[i] == ")" {
                while true {
                    if stack.last == "(" {
                        stack.removeLast()
                        break
                    }
                    output.append(stack.popLast()!)
                }
            }
            else if single_items_operations.contains(where: {$0 == operation}) {
                stack.append(operation)
                operation = ""
            }
            else {
                while stack.count > 0 && priority[inputStr[i]]! <= priority[stack.last!]! {
                    output.append(stack.popLast()!)
                }
                
                stack.append(inputStr[i])
            }
        }
    }
    
    if number.count != 0 {
        output.append(number)
    }
    
    while stack.count != 0 {
        output.append(stack.popLast()!)
    }
    
    return output
}

func calculate(input: [String]) -> Double {
    var inputStr = input
    var stack: [Double] = []
    
    for s in inputStr {
        if s.contains(where: {$0.isNumber}) {
            stack.append(Double(s)!)
        }
        else if single_items_operations.contains(where: {$0 == s}) {
            stack.append(makeOperation(number1: stack.popLast()!, number2: 0, symbol: s))
        }
        else if several_items_operations.contains(where: {$0 == s}) {
            var a = stack.popLast()
            var b = stack.popLast()
            
            stack.append(makeOperation(number1: a!, number2: b!, symbol: s))
        }
    }
    
    return stack[0]
}
