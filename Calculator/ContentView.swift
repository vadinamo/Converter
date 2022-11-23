//
//  ContentView.swift
//  Calculator
//
//  Created by Вадим Юрьев on 21.11.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CalculatorView(vm: ViewModel(cursorSymbol: "|"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
