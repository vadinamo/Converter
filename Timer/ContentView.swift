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
    
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Image(systemName: "timer.circle.fill")
                    Text((currentLanguage == "English") ?
                         "Timer" : "Таймер")
                    
                }
            
            SequenceView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text((currentLanguage == "English") ?
                         "Sequences" : "Последовательности")
                }
            
            SettingsView()
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
