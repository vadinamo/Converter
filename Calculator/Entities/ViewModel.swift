//
//  ViewModel.swift
//  Calculator
//
//  Created by Вадим Юрьев on 23.11.22.
//

import Foundation
import BigDecimal
import SwiftUI


class ViewModel: ObservableObject {
    @Published private var cursorIndex = 0
    var cursorSymbol: String
    
    @Published var input: String
    @Published var output: String
    
    @AppStorage("successToastToggle") private var successToastToggle = false
    @AppStorage("toastToggle") private var toastToggle = false
    @AppStorage("toastMessage") private var toastMessage = "Invalid input"
    
    init(cursorSymbol: String) {
        self.cursorSymbol = cursorSymbol
        self.input = cursorSymbol
        self.output = ""
        self.cursorIndex = 0
    }
    
    func moveCursorLeft() {
        if cursorIndex > 0 {
            self.input = input.replacingOccurrences(of: cursorSymbol, with: "")
            
            var i = cursorIndex - 1
            if !input[i].isNumber && !several_items_operations.contains(where: {$0 == input[i]}) && input[i] != "!" {
                while i >= 0 {
                    print(i)
                    if ((input[i] == "(" || input[i] == ")") && i != cursorIndex - 1) || several_items_operations.contains(where: {$0 == input[i]}) || input[i].isNumber {
                        i += 1
                        break
                    }
                    
                    i -= 1
                }
            }
            
            if i < 0 {
                i += 1
            }
            
            let start = input.prefix(i)
            let end = input.suffix(input.count - i)
            
            self.input = start + cursorSymbol + end
            self.cursorIndex = i
        }
    }
    
    func moveCursorRight() {
        if cursorIndex < input.replacingOccurrences(of: cursorSymbol, with: "").count {
            self.input = input.replacingOccurrences(of: cursorSymbol, with: "")
            
            var i = cursorIndex + 1
            if !several_items_operations.contains(where: {$0 == input[i]}) && !several_items_operations.contains(where: {$0 == input[cursorIndex]}) && input[i] != "!" && input[cursorIndex] != "(" {
                while i < input.count {
                    if input[i].isNumber || input[i] == ")" {
                        break
                    }
                    else if input[i] == "(" {
                        i += 1
                        break
                    }
                    i += 1
                }
            }
            
            let start = input.prefix(i)
            let end = input.suffix(input.count - i)
            
            self.input = start + cursorSymbol + end
            self.cursorIndex = i
        }
    }
    
    func inputValue(value: String) {
        let check = input.replacingOccurrences(of: cursorSymbol, with: "")
        
        if (several_items_operations.contains(where: {$0 == value}) || value == "!") {
            if (cursorIndex != 0 && several_items_operations.contains(where: {$0 == input[cursorIndex - 1]})) || several_items_operations.contains(where: {$0 == check[cursorIndex]}) {
                // two operations in row
                toastMessage = "Invalid operation input"
                toastToggle.toggle()
                return
            }
            
            else if input.replacingOccurrences(of: cursorSymbol, with: "")[cursorIndex - 1] == "(" && value != "-"{
                // expression cannot start with operation except minus
                toastMessage = "Expression cannot start with symbol except minus"
                toastToggle.toggle()
                return
            }
        }
        
        if value.replacingOccurrences(of: ".", with: "").isNumber && check[cursorIndex] != "!" &&
            (!(leftCheck(check: check) || check[cursorIndex - 1].isNumber || (check[cursorIndex - 1] == ".")) ||
             !(rightCheck(check: check) || check[cursorIndex].isNumber || check[cursorIndex] == ".")) {
            // invalid number input
            toastMessage = "Invalid number input"
            toastToggle.toggle()
            return
        }
        
        else if value == "pi" &&
                    (!leftCheck(check: check) ||
                     !rightCheck(check: check)) {
            // invalid pi input
            toastMessage = "Invalid pi input"
            toastToggle.toggle()
            return
        }
        
        else if single_items_operations.contains(where: {$0 == value}) && !leftCheck(check: check) && value != "!"{
            // invalid operation input
            toastMessage = "Invalid operation input"
            toastToggle.toggle()
            return
        }
        
        else if value == "(" && !leftCheck(check: check) {
            // invalid bracket input
            toastMessage = "Invalid bracket input"
            toastToggle.toggle()
            return
        }
        
        else if value == ")" {
            var stack: [String] = []
            for s in check {
                if s == "(" {
                    stack.append("(")
                }
                else if s == ")" {
                    stack.removeLast()
                }
            }
            
            if stack.count == 0 {
                // cannot input extra bracket
                toastMessage = "Unable to enter extra bracket"
                toastToggle.toggle()
                return
            }
        }
        
        else if value == "." {
            var leftIndex = cursorIndex
            while leftIndex > 0 {
                if leftIndex != cursorIndex && (check[leftIndex] == "(" || several_items_operations.contains(where: {$0 == check[leftIndex]})) {
                    leftIndex += 1
                    break
                }
                leftIndex -= 1
            }
            
            if check[leftIndex] == "(" {
                leftIndex += 1
            }
            
            var rightIndex = cursorIndex
            while rightIndex < check.count {
                if check[rightIndex] == ")" || several_items_operations.contains(where: {$0 == check[rightIndex]}) {
                    break
                }
                rightIndex += 1
            }
            
            if check.substring(with: leftIndex..<rightIndex).contains(where: {$0 == "."}) {
                toastMessage = "Number can contain only one dot"
                toastToggle.toggle()
                return
            }
        }
        self.input = check
        
        var val = value
        let start = input.prefix(cursorIndex)
        let end = input.suffix(input.count - cursorIndex)
        
        if !val.isNumber && val.needBracket {
            val += "("
        }
        
        self.input = start + val + cursorSymbol + end
        self.cursorIndex += val.count
    }
    
    func removeSymbol() {
        if input.replacingOccurrences(of: cursorSymbol, with: "").count > 0 && cursorIndex > 0 {
            self.input = input.replacingOccurrences(of: cursorSymbol, with: "")
            
            let rightIndex = cursorIndex
            var leftIndex = rightIndex - 1
            
            if (input[leftIndex] == "(" || input[leftIndex].isLetter) && !(leftIndex == 0 || !input[leftIndex - 1].isLetter) {
                while leftIndex > 0 {
                    if several_items_operations.contains(where: {$0 == input[leftIndex]}) || input[leftIndex] == "!" || (input[leftIndex] == "(" && leftIndex != rightIndex - 1) || input[leftIndex].isNumber || input[leftIndex] == ")" {
                        if rightIndex - leftIndex > 1 {
                            leftIndex += 1
                        }
                        break
                    }
                    leftIndex -= 1
                }
            }
            
            if input[leftIndex] == "(" && leftIndex != rightIndex - 1 {
                leftIndex += 1
            }
            
            var start = input.prefix(leftIndex)
            let end = input.suffix(input.count - rightIndex)
            
            if start.count != 0 && end.count != 0 {
                if several_items_operations.contains(where: {$0 == String(start.last!)}) &&
                    several_items_operations.contains(where: {$0 == String(end.first!)}) {
                    self.cursorIndex -= 1
                    start.removeLast()
                }
                else if start.last == "i" && end.first == "p" {
                    start.removeLast(2)
                    cursorIndex -= 2
                }
            }
            
            self.cursorIndex -= (rightIndex - leftIndex)
            self.input = start + cursorSymbol + end
        }
    }
    
    func calculate() {
        if input.count > 1000 {
            self.output = "Too much"
            return
        }
        let check = input.replacingOccurrences(of: cursorSymbol, with: "")
        for i in 0..<check.count - 1 {
            toastMessage = "Make sure that you insert multiply sign"
            if check[i].isNumber && check[i + 1].isLetter {
                toastToggle.toggle()
                return
            }
            else if check[i + 1].isNumber && check[i].isLetter {
                toastToggle.toggle()
                return
            }
        }
        
        let thread = Thread { [self] in
            self.output = "Computing..."
            self.output = Calculator.calculate(input: rpn(input: check))
        }
        thread.start()
        
        var timeRemaining = 20
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            timeRemaining -= 1
            print(timeRemaining)
            
            if thread.isFinished {
                timer.invalidate()
            }
            
            else if timeRemaining == 0 {
                thread.cancel()
                timer.invalidate()
                self.output = "Computing stopped"
            }
        })
    }
    
    func clear() {
        self.cursorIndex = 0
        self.input = cursorSymbol
        self.output = ""
    }
    
    func leftCheck(check: String) -> Bool {
        return cursorIndex == 0 || check[cursorIndex - 1] == "(" || several_items_operations.contains(where: {$0 == check[cursorIndex - 1]})
    }
    
    func rightCheck(check: String) -> Bool {
        return cursorIndex == check.count || check[cursorIndex] == ")" || (several_items_operations.contains(where: {$0 == check[cursorIndex]}))
    }
    
    func paste() {
        if let pastedString = UIPasteboard.general.string {
            if !pastedString.replacingOccurrences(of: ".", with: "").isNumber {
                toastMessage = "Only numbers can be pasted"
                toastToggle.toggle()
                return
            }
            if pastedString.filter({ $0 == "." }).count > 1 {
                toastMessage = "Number can contain only one dot"
                toastToggle.toggle()
                return
            }
            inputValue(value: pastedString)
            toastMessage = "Pasted"
            successToastToggle.toggle()
        }
    }
    func copy() {
        if !output.replacingOccurrences(of: ".", with: "").isNumber || output.count == 0 {
            toastMessage = "There is nothing to copy"
            toastToggle.toggle()
            return
        }
        UIPasteboard.general.string = output
        toastMessage = "Copied"
        successToastToggle.toggle()
    }
}
