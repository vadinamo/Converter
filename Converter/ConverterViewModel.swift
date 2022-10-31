//
//  ConverterViewModel.swift
//  Converter
//
//  Created by Вадим Юрьев on 30.10.22.
//

import SwiftUI
import BigDecimal

class ConverterViewModel: ObservableObject {
    let isPremium: String
    
    @Published private var cursorIndex = 1
    var cursorSymbol: String
    
    @Published var currentCategory: Int = 0
    
    @Published var type1: Int = 0
    @Published var type2: Int = 0
    
    @Published var input: String = ""
    var output: String {
        let value = BigDecimal(input.replacingOccurrences(of: cursorSymbol, with: "")) ?? 0
        var result = String(value / valueCoefficients[currentCategory][type1] * valueCoefficients[currentCategory][type2])

        if result.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "0", with: "").count == 0 {
            return "0"
        }
        
        if result.count > 20 {
            result = String(result.prefix(20))
        }
        
        return result
    }
    
    var width: CGFloat {
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            return UIScreen.main.bounds.width
        }
        else {
            return UIScreen.main.bounds.height
        }
    }
    
    var count: CGFloat {
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            return 4
        }
        else {
            return 5
        }
    }
    
    init(symbol: String) {
        self.cursorSymbol = symbol
        self.input = "\("0")\(symbol)"
        self.isPremium = Bundle.main.infoDictionary?["Premium"] as! String
    }
    
    func clearInput() {
        self.cursorIndex = 1
        self.input = "\("0")\(cursorSymbol)"
    }
    
    func cursorMoveLeft() {
        if cursorIndex > 0 {
            var characters = Array(input)
            characters.swapAt(cursorIndex - 1, cursorIndex)
            self.input = String(characters)
            self.cursorIndex -= 1
        }
    }
    
    func cursorMoveRight() {
        if cursorIndex < input.replacingOccurrences(of: cursorSymbol, with: "").count {
            var characters = Array(input)
            characters.swapAt(cursorIndex, cursorIndex + 1)
            self.input = String(characters)
            self.cursorIndex += 1
        }
    }
    
    func swap() -> String {
        if isPremium == "false" {
            return "Bomj"
        }
        if output.replacingOccurrences(of: ".", with: "").count <= 15 {
            cursorIndex = output.count
            input = "\(output)\(cursorSymbol)"
            let buf = type1
            type1 = type2
            type2 = buf
            return "Swapped"
        }
        else {
            return "Limit"
        }
    }
    
    func copy() -> String {
        if isPremium == "false" {
            return "Bomj"
        }
        UIPasteboard.general.string = output
        return "Copied"
    }
    
    func paste() -> String {
        if var myString = UIPasteboard.general.string {
            var length = myString.count
            if input.replacingOccurrences(of: cursorSymbol, with: "") == "0" {
                myString = "\(myString.replacingOccurrences(of: ",", with: "."))"
                self.cursorIndex = 0
            }
            else {
                var str = input.replacingOccurrences(of: cursorSymbol, with: "")
                let start = str.prefix(cursorIndex)
                let end = str.suffix(str.count - cursorIndex)
                
                myString = "\(start)\(myString.replacingOccurrences(of: ",", with: "."))\(end)"
            }
            if myString.count > 15 || myString.count == 15 && myString.last == "." {
                return "Limit"
            }
                
            let re = "[.0-9]+"
            let stringToCheck = myString.replacingOccurrences(of: re, with: "", options: [.regularExpression])
            if stringToCheck.count != 0 {
                return "Gavno"
            }
            
            if myString.filter({ $0 == "." }).count > 1 {
                return "Extra"
            }
            
            if myString.prefix(myString.count) == String(BigDecimal(myString) ?? 0).prefix(myString.count) {
                self.cursorIndex += length
                
                let start = myString.prefix(cursorIndex)
                let end = myString.suffix(myString.count - cursorIndex)
                
                self.input = "\(start)\(cursorSymbol)\(end)"
                return "Pasted"
            }
            return "Gavno"
        }
        
        return "Gavno"
    }
    
    func remove() {
        if input.replacingOccurrences(of: cursorSymbol, with: "").count > 1 && cursorIndex > 0 {
            self.input = input.replacingOccurrences(of: cursorSymbol, with: "")
            
            let start = input.prefix(cursorIndex - 1)
            let end = input.suffix(input.count - cursorIndex)
            
            let string = "\(start)\(cursorSymbol)\(end)"
            var convertedString = String(BigDecimal(string.replacingOccurrences(of: cursorSymbol, with: "")) ?? 0)
            if String(convertedString.suffix(2)) == ".0" {
                convertedString.removeLast(2)
            }
            if string.replacingOccurrences(of: cursorSymbol, with: "") != convertedString && string.replacingOccurrences(of: cursorSymbol, with: "") != "\(convertedString)\(".")" {
                self.input = "\(cursorSymbol)\(String(BigDecimal(string.replacingOccurrences(of: cursorSymbol, with: "")) ?? 0))"
                if String(input.suffix(2)) == ".0" {
                    self.input.removeLast(2)
                }
                self.cursorIndex = 0
            }
            else {
                self.input = string
                self.cursorIndex -= 1
            }
        }
        else if input.replacingOccurrences(of: cursorSymbol, with: "").count == 1 &&  input.replacingOccurrences(of: cursorSymbol, with: "") != "0"{
            self.input = "\("0")\(cursorSymbol)"
            self.cursorIndex = 1
        }
    }
    
    func dot() -> String {
        if input.contains(".") {
            return "Extra"
        }
        else if input.replacingOccurrences(of: cursorSymbol, with: "").replacingOccurrences(of: ".", with: "").count <= 15 && cursorIndex != 15 {
            self.input = input.replacingOccurrences(of: cursorSymbol, with: "")
            let start = input.prefix(cursorIndex)
            let end = input.suffix(input.count - cursorIndex)
            self.input = "\(start)\(".")\(cursorSymbol)\(end)"
            self.cursorIndex += 1
            return ""
        }
        else {
            return "Limit"
        }
    }
    
    func inputNumber(number: String) -> String{
        if input.replacingOccurrences(of: cursorSymbol, with: "").replacingOccurrences(of: ".", with: "").count < 15 {
            let buf = input
            
            if self.input == "\("0")\(cursorSymbol)" && number != "0" {
                self.input =  String(number) + cursorSymbol
            }
            else {
                self.input = input.replacingOccurrences(of: cursorSymbol, with: "")
                let start = input.prefix(cursorIndex)
                let end = input.suffix(input.count - cursorIndex)
                
                let length = input.count
                
                if String(BigDecimal("\(start)\(number)\(end)") ?? 0).prefix(length + 1) ==  "\(start)\(number)\(end)".prefix(length + 1) {
                    self.input = "\(start)\(number)\(cursorSymbol)\(end)"
                    self.cursorIndex += 1
                }
                else if input.contains(".") && (input.firstIndex(of: ".")?.utf16Offset(in: input))! < cursorIndex {
                    self.input = "\(start)\(number)\(cursorSymbol)\(end)"
                    self.cursorIndex += 1
                }
                else {
                    self.input = buf
                    return "ExtraZeros"
                }
            }
            return ""
        }
        else {
            return "Limit"
        }
    }
}
