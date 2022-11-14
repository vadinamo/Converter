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
                .tabItem {
                    Image(systemName: "timer.circle.fill")
                    Text((currentLanguage == "English") ?
                         "Timer" : "Таймер")
                    
                }
            SequenceView
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text((currentLanguage == "English") ?
                         "Sequences" : "Последовательности")
                }
            SettingsView
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text((currentLanguage == "English") ?
                         "Settings" : "Настройки")
                }
        }
        .accentColor(Color.Accent)
        .font(.system(size: CGFloat(fontSizes[currentFontSize] ?? 0)))
        .background()
    }
    
    @ViewBuilder
    var TimerView: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink {
                        NewTimerView
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    
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
        }
    }
    
    @ViewBuilder
    var SequenceView: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink {
                        NewSequenceView
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    
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
        .padding()
    }
    
    @ViewBuilder
    var NewTimerView: some View {
        VStack {
            Text("*new timer creating*")
            
            Spacer()
            
            Button(action: {}, label: {
                Text((currentLanguage == "English") ?
                     "Create" : "Создать")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color.Accent)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.Accent, lineWidth: 2)
                    )
            })
        }
        .padding()
    }
    
    @ViewBuilder
    var NewSequenceView: some View {
        VStack {
            Text("*new sequence creating*")
            
            Spacer()
            
            Button(action: {}, label: {
                Text((currentLanguage == "English") ?
                     "Create" : "Создать")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color.Accent)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.Accent, lineWidth: 2)
                    )
            })
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
