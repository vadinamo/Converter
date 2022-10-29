//
//  ConverterView.swift
//  Converter
//
//  Created by Вадим Юрьев on 10.09.22.
//

import SwiftUI
import AlertToast

struct ConverterView: View {
    @State private var orientation = UIDevice.current.orientation
    @State private var cursorIndex = 1
    
    @State var currentCategory: Int = 0
    
    @State var type1: Int = 0
    @State var type2: Int = 0
    
    @State var copyToast = false
    @State var pasteToast = false
    @State var invalidInputToast = false
    @State var symbolLimitToast = false
    @State var extraDotsToast = false
    @State var extraZerosToast = false
    @State var swapToast = false
    
    @State var input: String = "0|"
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
    
    let buttons: [[Buttons]] = [
        [.left, .right, .swap],
        [.seven, .eight, .nine, .copy],
        [.four, .five, .six, .paste],
        [.one, .two, .three, .remove],
        [.zero, .dot, .clear]
    ]
    
    var body: some View {
        ZStack {
            if orientation.isLandscape || UIScreen.main.bounds.height < UIScreen.main.bounds.width {
                HStack {
                    VStack {
                        inputs
                    }
                    Spacer()
                    VStack {
                        keyboard
                    }
                }.padding(.all)
            }
            else if orientation.isPortrait || UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                VStack {
                    inputs
                    Spacer()
                    keyboard
                }.padding(.all)
            }
        }
        .onAppear {
            orientation = UIApplication.shared.statusBarOrientation == .portrait ? UIDeviceOrientation.portrait : UIDeviceOrientation.landscapeLeft
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
    
    func buttonWidth(item: Buttons) -> CGFloat {
        if item == .zero {
            return (width - (4 * 12)) / count * 2
        }
        else if item == .left || item == .right {
            return (width - (4 * 12)) / count * 3 / 2
        }
            
        return (width - (5 * 12)) / count
    }
    
    func buttonHeight(item: Buttons) -> CGFloat {
        return (width - (5 * 12)) / count
    }
    
    func clearInput() {
        self.cursorIndex = 1
        self.input = "0|"
    }
    
    @ViewBuilder
    var inputs: some View {
        Picker("Category", selection: $currentCategory) {
            ForEach(0..<unitCategories.count) {
                Text(unitCategories[$0])
                    .font(.largeTitle)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .toast(isPresenting: $copyToast, duration: 1, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .regular, title: "Copied")
        }
        .toast(isPresenting: $pasteToast, duration: 1, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .regular, title: "Pasted")
        }
        .toast(isPresenting: $swapToast, duration: 1, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .regular, title: "Swaped")
        }
        .toast(isPresenting: $extraDotsToast, duration: 2, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .error(.red), title: "Input can contain only one dot")
        }
        .toast(isPresenting: $extraZerosToast, duration: 2, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .regular, title: "по тебе новинки плачут")
        }
        .toast(isPresenting: $invalidInputToast, duration: 2, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .regular, title: "хуйня переделывай")
        }
        .toast(isPresenting: $symbolLimitToast, duration: 3, tapToDismiss: false) {
            AlertToast(displayMode: .hud, type: .error(.red), title: "Max input length is 15 numbers")
        }
        
        Spacer()
        
        HStack {
            Picker("From type", selection: $type1) {
                ForEach(0..<unitTypes[currentCategory].count) {
                    Text(unitTypes[currentCategory][$0])
                        .font(.largeTitle)
                }
            }
            Spacer()
            Text(input)
                .font(.system(size: 18)).padding()
        }
        
        Spacer()
        
        HStack {
            Picker("To type", selection: $type2) {
                ForEach(0..<unitTypes[currentCategory].count) {
                    Text(unitTypes[currentCategory][$0])
                        .font(.largeTitle)
                }
            }
            Spacer()
            Text(output)
                .font(.system(size: 18)).padding()
        }
        
        Spacer()
    }
    
    @ViewBuilder
    var keyboard: some View {
        ForEach(buttons, id: \.self) { row in
            HStack {
                ForEach(row, id: \.self) { item in
                    Button(action: {
                        buttonTap(button: item)
                    }, label: {
                        item.buttonLabel
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .frame(
                                width: self.buttonWidth(item: item),
                                height: self.buttonHeight(item: item))
                            .background(item.buttonColor)
                            .cornerRadius(self.buttonHeight(item: item))
                    })
                }
            }
        }
    }
    
    func buttonTap(button: Buttons) {
        switch button {
        case .left:
            if cursorIndex > 0 {
                var characters = Array(input)
                characters.swapAt(cursorIndex - 1, cursorIndex)
                self.input = String(characters)
                self.cursorIndex -= 1
            }
            break
        case .right:
            if cursorIndex < input.replacingOccurrences(of: "|", with: "").count {
                var characters = Array(input)
                characters.swapAt(cursorIndex, cursorIndex + 1)
                self.input = String(characters)
                self.cursorIndex += 1
            }
            break
        case .swap:
            if output.replacingOccurrences(of: ".", with: "").count <= 15 {
                self.cursorIndex = output.count
                self.input = "\(output)\("|")"
                let buf = type1
                self.type1 = type2
                self.type2 = buf
                self.swapToast.toggle()
            }
            else {
                self.symbolLimitToast.toggle()
            }
            break
        case .copy:
            UIPasteboard.general.string = output
            self.copyToast.toggle()
            break
        case .paste:
            if var myString = UIPasteboard.general.string {
                if input.replacingOccurrences(of: "|", with: "") == "0" {
                    myString = "\(myString.replacingOccurrences(of: ",", with: "."))"
                }
                else {
                    myString = "\(input.replacingOccurrences(of: "|", with: ""))\(myString.replacingOccurrences(of: ",", with: "."))"
                }
                if myString.count > 15 || myString.count == 15 && myString.last == "." {
                    self.symbolLimitToast.toggle()
                    break
                }
                    
                let re = "[.0-9]+"
                let stringToCheck = myString.replacingOccurrences(of: re, with: "", options: [.regularExpression])
                if stringToCheck.count != 0 {
                    self.invalidInputToast.toggle()
                    break
                }
                
                if myString.filter({ $0 == "." }).count > 1 {
                    self.invalidInputToast.toggle()
                    break
                }
                
                clearInput()
                self.cursorIndex = myString.count
                self.input = "\(myString)\("|")"
                self.pasteToast.toggle()
            }
            break
        case .remove:
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
            break
        case .clear:
            clearInput()
            break
        case .dot:
            if input.contains(".") {
                self.extraDotsToast.toggle()
            }
            else if input.replacingOccurrences(of: "|", with: "").replacingOccurrences(of: ".", with: "").count <= 15 && cursorIndex != 15 {
                self.input = input.replacingOccurrences(of: "|", with: "")
                let start = input.prefix(cursorIndex)
                let end = input.suffix(input.count - cursorIndex)
                self.input = "\(start)\(button.rawValue)\("|")\(end)"
                self.cursorIndex += 1
            }
            else {
                self.symbolLimitToast.toggle()
            }
            break
        default:
            if input.replacingOccurrences(of: "|", with: "").replacingOccurrences(of: ".", with: "").count < 15 {
                let buf = input
                
                if self.input == "0|" && button != .zero {
                    self.input =  button.rawValue + "|"
                }
                else {
                    self.input = input.replacingOccurrences(of: "|", with: "")
                    let start = input.prefix(cursorIndex)
                    let end = input.suffix(input.count - cursorIndex)
                    
                    let length = input.count
                    
                    if String(Double("\(start)\(button.rawValue)\(end)") ?? 0).prefix(length + 1) ==  "\(start)\(button.rawValue)\(end)".prefix(length + 1) {
                        self.input = "\(start)\(button.rawValue)\("|")\(end)"
                        self.cursorIndex += 1
                    }
                    else if input.contains(".") && (input.firstIndex(of: ".")?.utf16Offset(in: input))! < cursorIndex {
                        self.input = "\(start)\(button.rawValue)\("|")\(end)"
                        self.cursorIndex += 1
                    }
                    else {
                        self.extraZerosToast.toggle()
                        self.input = buf
                    }
                }
            }
            else {
                self.symbolLimitToast.toggle()
            }
            break
        }
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}












struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView()
            .preferredColorScheme(.dark)
    }
}
