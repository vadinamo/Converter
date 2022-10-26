//
//  ConverterView.swift
//  Converter
//
//  Created by Вадим Юрьев on 10.09.22.
//

import SwiftUI

struct ConverterView: View {
    @State var currentCategory: Int = 0
    
    @State var type1: Int = 0
    @State var type2: Int = 0
    
    @State var input: String = "0"
    
    var output: String {
        var value = Double(input) ?? 0
        return String(value / valueCoefficients[currentCategory][type1] * valueCoefficients[currentCategory][type2])
    }
    
    let buttons: [[Buttons]] = [
        [.left, .right, .swap],
        [.seven, .eight, .nine, .copy],
        [.four, .five, .six, .paste],
        [.one, .two, .three, .remove],
        [.zero, .dot, .clear]
    ]
    
    var body: some View {
        VStack {
            Picker("Category", selection: $currentCategory) {
                ForEach(0..<unitCategories.count) {
                    Text(unitCategories[$0])
                        .font(.largeTitle)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
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
            
            ForEach(buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            buttonTap(button: item)
                        }, label: {
                            Text(item.rawValue)
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
        }.padding(.all)
    }
    
    func buttonWidth(item: Buttons) -> CGFloat {
        if item == .zero {
            return (UIScreen.main.bounds.width - (4*12)) / 4 * 2
        }
        else if item == .left || item == .right {
            return (UIScreen.main.bounds.width - (4*12)) / 4 * 3 / 2
        }
            
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight(item: Buttons) -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonTap(button: Buttons) {
        switch button {
        case .left:
            break
        case .right:
            break
        case .swap:
            if output.count < 15 {
                self.input = output
            }
            break
        case .copy:
            break
        case .paste:
            break
        case .remove:
            if input.count > 1 {
                self.input.removeLast()
            }
            else {
                self.input = "0"
            }
            break
        case .clear:
            self.input = "0"
            break
        case .dot:
            if !input.contains(".") {
                self.input = "\(self.input)\(button.rawValue)"
            }
            break
        default:
            if input.count < 15 {
                if self.input == "0" {
                    input =  button.rawValue
                }
                else {
                    self.input = "\(self.input)\( button.rawValue)"
                }
            }
            break
        }
    }
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView()
            .preferredColorScheme(.dark)
    }
}
