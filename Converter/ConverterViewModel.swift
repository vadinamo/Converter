//
//  ConverterViewModel.swift
//  Converter
//
//  Created by Вадим Юрьев on 30.10.22.
//

import SwiftUI

class ConverterViewModel: ObservableObject {
    @Published private var cursorIndex = 1
    
    @Published var currentCategory: Int = 0
    
    @Published var type1: Int = 0
    @Published var type2: Int = 0
    
    @Published var input: String = "0|"
    var output: String {
        let value = Double(input.replacingOccurrences(of: "|", with: "")) ?? 0
        var result = String(value / valueCoefficients[currentCategory][type1] * valueCoefficients[currentCategory][type2])
        if String(result.suffix(2)) == ".0" {
            result.removeLast(2)
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
    
    init() {
        
    }
    
    func clearInput() {
        self.cursorIndex = 1
        self.input = "0|"
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
        if cursorIndex < input.replacingOccurrences(of: "|", with: "").count {
            var characters = Array(input)
            characters.swapAt(cursorIndex, cursorIndex + 1)
            self.input = String(characters)
            self.cursorIndex += 1
        }
    }
    
    func swap() -> String {
        if output.replacingOccurrences(of: ".", with: "").count <= 15 {
            cursorIndex = output.count
            input = "\(output)\("|")"
            let buf = type1
            type1 = type2
            type2 = buf
            return "Swapped"
        }
        else {
            return "Limit"
        }
    }
    
    func copy() {
        UIPasteboard.general.string = output
    }
    
    func paste() -> String {
        if var myString = UIPasteboard.general.string {
            if input.replacingOccurrences(of: "|", with: "") == "0" {
                myString = "\(myString.replacingOccurrences(of: ",", with: "."))"
            }
            else {
                myString = "\(input.replacingOccurrences(of: "|", with: ""))\(myString.replacingOccurrences(of: ",", with: "."))"
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
            
            clearInput()
            myString = String(Double(myString) ?? 0)
            self.cursorIndex = myString.count
            self.input = "\(myString)\("|")"
            return "Pasted"
        }
        
        return "Gavno"
    }
    
    func remove() {
        if input.replacingOccurrences(of: "|", with: "").count > 1 && cursorIndex > 0 {
            self.input = input.replacingOccurrences(of: "|", with: "")
            
            let start = input.prefix(cursorIndex - 1)
            let end = input.suffix(input.count - cursorIndex)
            
            let string = "\(start)\("|")\(end)"
            var convertedString = String(Double(string.replacingOccurrences(of: "|", with: "")) ?? 0)
            if String(convertedString.suffix(2)) == ".0" {
                convertedString.removeLast(2)
            }
            if string.replacingOccurrences(of: "|", with: "") != convertedString && string.replacingOccurrences(of: "|", with: "") != "\(convertedString)\(".")" {
                self.input = "\("|")\(String(Double(string.replacingOccurrences(of: "|", with: "")) ?? 0))"
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
        else if input.replacingOccurrences(of: "|", with: "").count == 1 &&  input.replacingOccurrences(of: "|", with: "") != "0"{
            self.input = "0|"
            self.cursorIndex = 1
        }
    }
    
    func dot() -> String {
        if input.contains(".") {
            return "Extra"
        }
        else if input.replacingOccurrences(of: "|", with: "").replacingOccurrences(of: ".", with: "").count <= 15 && cursorIndex != 15 {
            self.input = input.replacingOccurrences(of: "|", with: "")
            let start = input.prefix(cursorIndex)
            let end = input.suffix(input.count - cursorIndex)
            self.input = "\(start)\(".")\("|")\(end)"
            self.cursorIndex += 1
            return ""
        }
        else {
            return "Limit"
        }
    }
    
    func inputNumber(number: String) -> String{
        if input.replacingOccurrences(of: "|", with: "").replacingOccurrences(of: ".", with: "").count < 15 {
            let buf = input
            
            if self.input == "0|" && number != "0" {
                self.input =  String(number) + "|"
            }
            else {
                self.input = input.replacingOccurrences(of: "|", with: "")
                let start = input.prefix(cursorIndex)
                let end = input.suffix(input.count - cursorIndex)
                
                let length = input.count
                
                if String(Double("\(start)\(number)\(end)") ?? 0).prefix(length + 1) ==  "\(start)\(number)\(end)".prefix(length + 1) {
                    self.input = "\(start)\(number)\("|")\(end)"
                    self.cursorIndex += 1
                }
                else if input.contains(".") && (input.firstIndex(of: ".")?.utf16Offset(in: input))! < cursorIndex {
                    self.input = "\(start)\(number)\("|")\(end)"
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
