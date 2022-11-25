//
//  CalculatorView.swift
//  Calculator
//
//  Created by Вадим Юрьев on 21.11.22.
//

import SwiftUI

struct CalculatorView: View {
    @AppStorage("scientific") private var isScientific = true
    
    @ObservedObject var vm: ViewModel
    @State var output = ""
    
    var buttons: [[Buttons]] {
        if !isScientific {
            return [
                [.left, .right],
                [.calculate, .clear, .remove],
                [.seven, .eight, .nine, .plus],
                [.four, .five, .six, .minus],
                [.one, .two, .three, .multiply],
                [.swapKeyboard, .zero, .dot, .divide]
            ]
        }
        
        return [
            [.left, .right],
            [.sin, .cos, .tg, .ctg, .calculate],
            [.pow, .pi, .exp, .lg, .ln],
            [.factorial, .leftBracket, .rightBracket, .clear, .remove],
            [.seven, .eight, .nine, .plus],
            [.four, .five, .six, .minus],
            [.one, .two, .three, .multiply],
            [.swapKeyboard, .zero, .dot, .divide],
        ]
    }
    
    
    var body: some View {
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
            keyboard
        }
        .padding()
        .preferredColorScheme(.dark)
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
            return (width - (5 * 12)) / (count)
        }
        else if item == .left || item == .right {
            return (width - (4 * 12)) / count * 2
        }
        else {
            if isScientific {
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
            let cur = CGFloat((isScientific) ? 14 : 5)
            return (width - (cur * 12)) / (count)
        }
        else {
            if isScientific {
                return (width - (5 * 12)) / (count * 2)
            }
            else {
                return (width) / (count * 2)
            }
        }
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
                            .font(isScientific ? .none : .largeTitle)
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
        case .calculate:
            vm.calculate()
            break
        case .swapKeyboard:
            isScientific.toggle()
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
