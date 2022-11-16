//
//  NewSequenceView.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI

struct NewSequenceView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    @State private var sequenceTitle: String = ""
    @State private var sequenceColor: Color = Color.Accent
    @State private var timerActions: [TimerAction] = []
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            TextField(
                (currentLanguage == "English") ? "Title" : "Название",
                text: $sequenceTitle
            )
            
            Divider().padding()
            
            ColorPicker((currentLanguage == "English") ? "Background color" : "Цвет фона",
                        selection: $sequenceColor, supportsOpacity: false)
            
            Divider().padding()
            
            Text((currentLanguage == "English") ?
                 "Timers" : "Таймеры").fontWeight(.bold)
            
            HStack {
                VStack {
                    Button(action: { timerActions.append(TimerAction(duration: 10, type: "Preparation")) },
                           label: { GetButtonLabel(systemImage: "figure.walk")
                    })
                    Text((currentLanguage == "English") ?
                         "Preparation" : "Подготовка")
                }
                VStack {
                    Button(action: { timerActions.append(TimerAction(duration: 10, type: "Training")) },
                           label: { GetButtonLabel(systemImage: "figure.strengthtraining.traditional")
                    })
                    Text((currentLanguage == "English") ?
                         "Training" : "Тренировка")
                }
                VStack {
                    Button(action: { timerActions.append(TimerAction(duration: 10, type: "Resting")) },
                           label: { GetButtonLabel(systemImage: "figure.stand")
                    })
                    Text((currentLanguage == "English") ?
                         "Resting" : "Отдых")
                }
            }
            
            List {
                ForEach(0..<timerActions.count, id: \.self) { i in
                    VStack {
                        HStack {
                            Image(systemName: actionImages[timerActions[i].type] ?? "")
                            Text(((currentLanguage == "English") ? timerActions[i].type : typesLocale[timerActions[i].type]) ?? "")
                        }
                        
                        HStack {
                            Button(action: { if timerActions[i].duration > 0 {
                                timerActions[i].duration -= 1
                            }},
                                   label: {
                                Image(systemName: "minus.circle.fill")
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Text(String(timerActions[i].duration))
                            Spacer()
                            Button(action: { timerActions[i].duration += 1 },
                                   label: {
                                Image(systemName: "plus.circle.fill")
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .foregroundColor(TextColor(color: sequenceColor))
                    .listRowBackground(sequenceColor)
                }
                .onDelete { indexSet in
                    timerActions.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, index in
                    timerActions.move(fromOffsets: indexSet, toOffset: index)
                }
            }
            
            Spacer()
            
            Button(action: {
                if sequenceTitle == "" {
                    sequenceTitle = (currentLanguage == "English") ? "Timer" : "Таймер"
                }
                vm.AddSequence(sequence: Sequence(name: sequenceTitle,
                                             color: sequenceColor,
                                             timers: timerActions))
                self.presentationMode.wrappedValue.dismiss()
            },
                   label: {
                Text((currentLanguage == "English") ? "Create" : "Создать")
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
}
