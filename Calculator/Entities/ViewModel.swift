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
            var characters = Array(input)
            characters.swapAt(cursorIndex - 1, cursorIndex)
            self.input = String(characters)
            self.cursorIndex -= 1
        }
    }
    
    func moveCursorRight() {
        if cursorIndex < input.replacingOccurrences(of: cursorSymbol, with: "").count {
            var characters = Array(input)
            characters.swapAt(cursorIndex, cursorIndex + 1)
            self.input = String(characters)
            self.cursorIndex += 1
        }
    }
    
    func inputValue(value: String) {
        if (several_items_operations.contains(where: {$0 == value}) || value == "!") && (cursorIndex == 0 ||
            several_items_operations.contains(where: {$0 == input[cursorIndex - 1]})) {
            return
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
