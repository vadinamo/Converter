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
    @ObservedObject var vm: ConverterViewModel
    
    @State var copyToast = false
    @State var pasteToast = false
    @State var invalidInputToast = false
    @State var symbolLimitToast = false
    @State var extraDotsToast = false
    @State var extraZerosToast = false
    @State var swapToast = false
    
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
            return (vm.width - (4 * 12)) / vm.count * 2
        }
        else if item == .left || item == .right {
            return (vm.width - (4 * 12)) / vm.count * 3 / 2
        }
            
        return (vm.width - (5 * 12)) / vm.count
    }
    
    func buttonHeight(item: Buttons) -> CGFloat {
        return (vm.width - (5 * 12)) / vm.count
    }
    
    @ViewBuilder
    var inputs: some View {
        Picker("Category", selection: $vm.currentCategory) {
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
            Picker("From type", selection: $vm.type1) {
                ForEach(0..<unitTypes[vm.currentCategory].count) {
                    Text(unitTypes[vm.currentCategory][$0])
                        .font(.largeTitle)
                }
            }
            Spacer()
            Text(vm.input)
                .font(.system(size: 18)).padding()
        }
        
        Spacer()
        
        HStack {
            Picker("To type", selection: $vm.type2) {
                ForEach(0..<unitTypes[vm.currentCategory].count) {
                    Text(unitTypes[vm.currentCategory][$0])
                        .font(.largeTitle)
                }
            }
            Spacer()
            Text(vm.output)
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
            vm.cursorMoveLeft()
            break
        case .right:
            vm.cursorMoveRight()
            break
        case .swap:
            switch vm.swap() {
            case "Swapped":
                self.copyToast.toggle()
                break
            default:
                self.symbolLimitToast.toggle()
                break
            }
            break
        case .copy:
            vm.copy()
            self.copyToast.toggle()
            break
        case .paste:
            switch vm.paste() {
            case "Limit":
                self.symbolLimitToast.toggle()
                break
            case "Gavno":
                self.invalidInputToast.toggle()
                break
            default:
                self.pasteToast.toggle()
                break
            }
            break
        case .remove:
            vm.remove()
            break
        case .clear:
            vm.clearInput()
            break
        case .dot:
            switch vm.dot() {
            case "Extra":
                self.extraDotsToast.toggle()
                break
            case "Limit":
                self.symbolLimitToast.toggle()
                break
            default:
                break
            }
            break
        default:
            switch vm.inputNumber(number: button.rawValue) {
            case "ExtraZeros":
                self.extraZerosToast.toggle()
                break
            case "Limit":
                self.symbolLimitToast.toggle()
                break
            default:
                break
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
