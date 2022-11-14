//
//  NewTimerView.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI


struct NewTimerView: View {
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    
    func GetButtonLabel(systemImage: String) -> some View {
        return Image(systemName: systemImage)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.Accent)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.Accent, lineWidth: 2)
            )
    }
    
    var body: some View {
        VStack {
            Text((currentLanguage == "English") ?
                 "Timer type" : "Тип таймера")
            HStack {
                VStack {
                    Text((currentLanguage == "English") ?
                         "Preparation" : "Подготовка")
                    Button(action: {}, label: {
                        GetButtonLabel(systemImage: "figure.walk")
                    })
                }
                
                VStack {
                    Text((currentLanguage == "English") ?
                         "Training" : "Тренировка")
                    Button(action: {}, label: {
                        GetButtonLabel(systemImage: "figure.strengthtraining.traditional")
                    })
                }
                
                VStack {
                    Text((currentLanguage == "English") ?
                         "Resting" : "Отдых")
                    Button(action: {}, label: {
                        GetButtonLabel(systemImage: "figure.stand")
                    })
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.Accent)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.Accent, lineWidth: 2)
            )
            
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
