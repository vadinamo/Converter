//
//  NewSequenceView.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI

struct NewSequenceView: View {
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    
    var body: some View {
            VStack {
                Text((currentLanguage == "English") ?
                     "Timers" : "Таймеры")
                
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
}
