//
//  ViewModel.swift
//  Calculator
//
//  Created by Вадим Юрьев on 23.11.22.
//

import Foundation


class ViewModel: ObservableObject {
    @Published private var cursorIndex = 0
    var cursorSymbol: String
    
    @Published var input: String
    
    init(cursorSymbol: String) {
        self.cursorSymbol = cursorSymbol
        self.input = cursorSymbol
        self.cursorIndex = 0
    }
    
    func moveCursorLeft() {
        if cursorIndex > 0 {
            self.input = input.replacingOccurrences(of: cursorSymbol, with: "")
            
            var i = cursorIndex - 1
            if !input[i].isNumber && !several_items_operations.contains(where: {$0 == input[i]}) {
                while i > 0 {
                    if ((input[i] == "(" || input[i] == ")") && i != cursorIndex - 1) || several_items_operations.contains(where: {$0 == input[i]}) || input[i].isNumber {
                        i += 1
                        break
                    }
                    
                    i -= 1
                }
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
            if !several_items_operations.contains(where: {$0 == input[i]}) && !several_items_operations.contains(where: {$0 == input[cursorIndex]}) {
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
        if (several_items_operations.contains(where: {$0 == value}) || value == "!") {
            if cursorIndex == 0 || several_items_operations.contains(where: {$0 == input[cursorIndex - 1]}) {
                return
            }
            
            else if input.replacingOccurrences(of: cursorSymbol, with: "")[cursorIndex - 1] == "(" && value != "-"{
                return
            }
        }
        
        var val = value
        self.input = input.replacingOccurrences(of: cursorSymbol, with: "")
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
            let start = input.prefix(cursorIndex - 1)
            let end = input.suffix(input.count - cursorIndex)
            
            self.cursorIndex -= 1
            self.input = start + cursorSymbol + end
        }
    }
    
    func clear() {
        self.cursorIndex = 0
        self.input = cursorSymbol
    }
}
