//
//  SettingsView.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("darkMode") private var darkMode = false
    
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    @AppStorage("currentFontSize") private var currentFontSize = "Small"
    
    var body: some View {
        VStack {
            Toggle(isOn: $darkMode.animation(), label: {
                Text((currentLanguage == "English") ?
                     "Dark mode" : "Темная тема")
            })
            
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
                        Text(((currentLanguage == "English") ?
                              $0 : fontsLocale[$0]) ?? "")
                    }
                }
            }
            
            Spacer()
            Divider()
        }
        .padding()
    }
}
