//
//  TimerView.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI

struct TimerView: View {
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    @AppStorage("currentFontSize") private var currentFontSize = "Small"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink {
                        NewTimerView()
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
}
