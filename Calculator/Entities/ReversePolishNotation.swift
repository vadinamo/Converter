//
//  ReversePolishNotation.swift
//  Calculator
//
//  Created by Вадим Юрьев on 25.11.22.
//

import Foundation
import BigDecimal


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

func rpn(input: String) -> [String] {
    let inputStr = completeString(string: input).replacingOccurrences(of: "pi", with: "3.141592653589793")
    
    var stack: [String] = []
    var number = ""
    var operation = ""
    
    var output: [String] = []
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

func calculate(input: [String]) -> String {
    let inputStr = input
    var stack: [BigDecimal] = []
    
    for s in inputStr {
        if s.contains(where: {$0.isNumber}) {
            stack.append(BigDecimal(s)!)
        }
        else if single_items_operations.contains(where: {$0 == s}) {
            do {
                if stack.count == 0 {
                    throw CalculateErrors.InvalidArgument
                }
                try stack.append(makeOperation(number1: stack.popLast()!, number2: 0, symbol: s))
            }
            catch CalculateErrors.DivisionByZero {
                return "Division by zero"
            }
            catch CalculateErrors.Overload {
                return "Overload"
            }
            catch CalculateErrors.ShitFactorial {
                return "Factorial can only be calculated from an integer"
            }
            catch CalculateErrors.NotExists {
                return "Trigonometrical function does not exists for current argument"
            }
            catch {
                return "Invalid argument"
            }
        }
        else if several_items_operations.contains(where: {$0 == s}) {
            do {
                let a = stack.popLast()
                let b = stack.popLast()
                if a == nil || b == nil {
                    throw CalculateErrors.InvalidArgument
                }
                try stack.append(makeOperation(number1: a!, number2: b!, symbol: s))
                
            }
            catch CalculateErrors.DivisionByZero {
                return "Division by zero"
            }
            catch CalculateErrors.Overload {
                return "Overload"
            }
            catch {
                return "Invalid argument"
            }
        }
    }
    if stack.count == 0 {
        return "nan"
    }
    return String(stack[0]).contains(where: {$0 == "."}) ?
    period(string: String(String(stack[0]).prefix(String(stack[0]).count - 1))) : String(stack[0])
}

func period(string: String) -> String {
    let stringCheck = String(string.suffix(string.count - string.distance(of: ".")! - 1))
    if stringCheck.count < 50 {
        return string
    }
    
    for count in 1..<stringCheck.count {  // count -- длина просматриваемого периода
        var i = 0  // i -- стартовый индекс периода
        let p = stringCheck.prefix(count)  // p -- потенциальный период
        
        var period = true
        while i < stringCheck.count {
            if i + count < stringCheck.count {
                let check = stringCheck.substring(with: i..<i + count)
                if check != p {
                    period = false
                    break
                }
                i += p.count
            }
            else if i < stringCheck.count {
                let check = stringCheck.substring(with: i..<i + (stringCheck.count - i))
                if check != p.prefix(check.count) {
                    period = false
                    break
                }
                break
            }
            else {
                break
            }
        }
        
        if period {
            return ("\(string.prefix(string.distance(of: ".")! + 1))(\(p))")
        }
    }
    
    return string
}
