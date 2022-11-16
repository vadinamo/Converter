//
//  ContentView.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI

enum TabType: Int {
    case timer
    case sequence
    case settings
}

struct ContentView: View {
    @AppStorage("darkMode") private var darkMode = false
    
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    @AppStorage("currentFontSize") private var currentFontSize = "Small"
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        TabView {
            SequenceView(vm: vm)
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text((currentLanguage == "English") ?
                         "Sequences" : "Последовательности")
                }
            
            SettingsView(vm: vm)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text((currentLanguage == "English") ?
                         "Settings" : "Настройки")
                }
        }
        .accentColor(Color.Accent)
        .font(.system(size: CGFloat(fontSizes[currentFontSize] ?? 0)))
        .background()
        .preferredColorScheme(darkMode ? .dark : .light)
    }
}
