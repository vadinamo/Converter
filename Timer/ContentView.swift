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
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @State var darkMode = false
    
    @State var currentLanguage = "English"
    @State var currentFontSize = "Small"
    
    var body: some View {
        TabView {
            TimerView
            SequenceView
            SettingsView
        }
        .accentColor(Color.Accent)
        .font(.system(size: CGFloat(fontSizes[currentFontSize] ?? 0)))
        .background()
    }
    
    @ViewBuilder
    var TimerView: some View {
        VStack {
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "plus.circle.fill")
                })
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "square.and.pencil.circle.fill")
                })
            }
            .font(.system(size: CGFloat(fontSizes[currentFontSize] ?? 0)))
            
            Text((currentLanguage == "English") ?
                 "Timer" : "Таймер")
            
            Spacer()
            Divider()
        }
        .padding()
        .tabItem {
            Image(systemName: "timer.circle.fill")
            Text((currentLanguage == "English") ?
                 "Timer" : "Таймер")
            
        }
        
    }
    
    @ViewBuilder
    var SequenceView: some View {
        VStack {
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "plus.circle.fill")
                })
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "square.and.pencil.circle.fill")
                })
            }
            .font(.system(size: CGFloat(fontSizes[currentFontSize] ?? 0)))
            
            Text((currentLanguage == "English") ?
                 "Sequences" : "Последовательности")
            
            Spacer()
            Divider()
        }
        .padding()
        .tabItem {
            Image(systemName: "list.bullet.clipboard")
            Text((currentLanguage == "English") ?
                 "Sequences" : "Последовательности")
        }
    }
    
    @ViewBuilder
    var SettingsView: some View {
        VStack {
            Toggle(isOn: $darkMode.animation(), label: {
                Text((currentLanguage == "English") ?
                     "Dark mode" : "Темная тема")
            }).onChange(of: darkMode) {
                (state) in changeDarkMode(state: state)
            }
            
            HStack {
                Text((currentLanguage == "English") ?
                     "Language" : "Язык")
                Spacer()
                Picker("Language", selection: $currentLanguage.animation()) {
                    ForEach(languages, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            HStack {
                Text((currentLanguage == "English") ?
                     "Font size" : "Размер шрифта")
                Spacer()
                Picker("Font size", selection: $currentFontSize.animation()) {
                    ForEach(fonts, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Spacer()
            Divider()
        }
        .tabItem {
            Image(systemName: "gearshape.fill")
            Text((currentLanguage == "English") ?
                 "Settings" : "Настройки")
        }
        .padding()
    }
    
    func setAppTheme() {
        darkMode = UserDefaultsUtils.shared.getDarkMode()
        changeDarkMode(state: darkMode)
    }
    
    func changeDarkMode(state: Bool) {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = state ? .dark : .light
        UserDefaultsUtils.shared.setDarkMode(enable: state)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
