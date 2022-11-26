//
//  CalculatorView.swift
//  Calculator
//
//  Created by Вадим Юрьев on 21.11.22.
//

import SwiftUI

struct CalculatorView: View {
    @State private var orientation = UIDevice.current.orientation
    @AppStorage("scientific") private var isScientific = true
    
    @ObservedObject var vm: ViewModel
    @State var output = ""
    
    var topButtons: [[Buttons]] {
        if !isScientific && !(orientation.isLandscape || UIScreen.main.bounds.height < UIScreen.main.bounds.width) {
            return [
                [.left, .right],
                [.calculate, .clear, .remove]
            ]
        }
        
        return [
            [.left, .right],
            [.sin, .cos, .tg, .ctg, .calculate],
            [.pow, .pi, .exp, .lg, .ln],
            [.factorial, .leftBracket, .rightBracket, .clear, .remove]
        ]
    }
    
    var bottomButtons: [[Buttons]] {
        return [
            [.seven, .eight, .nine, .plus],
            [.four, .five, .six, .minus],
            [.one, .two, .three, .multiply],
            [.swapKeyboard, .zero, .dot, .divide]
        ]
    }
    
    
    var body: some View {
        ZStack {
            if orientation.isLandscape || UIScreen.main.bounds.height < UIScreen.main.bounds.width {
                VStack {
                    info
                    Spacer()
                    HStack {
                        topButtonsView
                        bottomButtonsView
                    }
                }
            }
            else if orientation.isPortrait || UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                VStack {
                    info
                    topButtonsView
                    bottomButtonsView
                }
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .onAppear {
            orientation = UIApplication.shared.statusBarOrientation == .portrait ? UIDeviceOrientation.portrait : UIDeviceOrientation.landscapeLeft
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
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
    
    func buttonWidth(item: Buttons) -> CGFloat {
        if item == .seven || item == .eight || item == .nine || item == .plus ||
            item == .four || item == .five || item == .six || item == .minus ||
            item == .one || item == .two || item == .three || item == .multiply ||
            item == .swapKeyboard || item == .zero || item == .dot || item == .divide {
            
            return (width - (5 * 12)) / (count) * (UIScreen.main.bounds.height < UIScreen.main.bounds.width ? 1.2 : 1)
        }
        else if item == .left || item == .right {
            return (width - (4 * 12)) / count * (UIScreen.main.bounds.height < UIScreen.main.bounds.width ? 3.05 : 2)
        }
        else {
            if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
                return (width - (5 * 12)) / (count) * 1.2
            }
            else if isScientific {
                return (width - (5 * 12)) / (count * 1.3)
            }
            else {
                return (width) / count * 1.15
            }
        }
    }
    
    func buttonHeight(item: Buttons) -> CGFloat {
        if item == .seven || item == .eight || item == .nine || item == .plus ||
            item == .four || item == .five || item == .six || item == .minus ||
            item == .one || item == .two || item == .three || item == .multiply ||
            item == .swapKeyboard || item == .zero || item == .dot || item == .divide {
            let cur = CGFloat((isScientific || UIScreen.main.bounds.height < UIScreen.main.bounds.width) ? 14 : 5)
            return (width - (cur * 12)) / (count)
        }
        else {
            if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
                let cur = CGFloat((isScientific || UIScreen.main.bounds.height < UIScreen.main.bounds.width) ? 14 : 5)
                return (width - (cur * 12)) / (count)
            }
            else if isScientific {
                return (width - (5 * 12)) / (count * 2)
            }
            else {
                return (width) / (count * 2)
            }
        }
    }
    
    
    @ViewBuilder
    var topButtonsView: some View {
        VStack {
            ForEach(topButtons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            buttonTap(button: item)
                        }, label: {
                            item.buttonLabel
                                .font((isScientific || UIScreen.main.bounds.height < UIScreen.main.bounds.width) ? .none : .largeTitle)
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
    }
    
    @ViewBuilder
    var bottomButtonsView: some View {
        VStack {
            ForEach(bottomButtons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            buttonTap(button: item)
                        }, label: {
                            item.buttonLabel
                                .font((isScientific || UIScreen.main.bounds.height < UIScreen.main.bounds.width) ? .none : .largeTitle)
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
    }
    
    @ViewBuilder
    var info: some View {
        VStack {
            ScrollView {
                VStack {
                    Spacer()
                    HStack {
                        Text(vm.input)
                        Spacer()
                    }
                }
            }
            Spacer()
            ScrollView {
                VStack {
                    Spacer()
                    HStack {
                        Text(vm.output)
                        Spacer()
                    }
                }
            }
        }
    }
    
    func buttonTap(button: Buttons) {
        switch button {
        case .calculate:
            vm.calculate()
            break
        case .swapKeyboard:
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                isScientific.toggle()
            }
            break
        case .left:
            vm.moveCursorLeft()
            break
        case .right:
            vm.moveCursorRight()
            break
        case .clear:
            vm.clear()
            break
        case .remove:
            vm.removeSymbol()
            break
        default:
            vm.inputValue(value: button.rawValue)
            break
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
