//
//  EditSequenceView.swift
//  Timer
//
//  Created by Вадим Юрьев on 15.11.22.
//

import SwiftUI

struct EditSequenceView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    
    @ObservedObject var vm: ViewModel
    @State var sequence: Sequence
    
    var body: some View {
        VStack {
            TextField(
                (currentLanguage == "English") ? "Title" : "Название",
                text: $sequence.name
            )
            
            Divider().padding()
            
            ColorPicker((currentLanguage == "English") ? "Background color" : "Цвет фона",
                        selection: $sequence.color, supportsOpacity: false)
            
            Divider().padding()
            
            Text((currentLanguage == "English") ?
                 "Timers" : "Таймеры").fontWeight(.bold)
            
            HStack {
                VStack {
                    Button(action: { sequence.timers.append(TimerAction(duration: 10, type: "Preparation")) },
                           label: { GetButtonLabel(systemImage: "figure.walk")
                    })
                    Text((currentLanguage == "English") ?
                         "Preparation" : "Подготовка")
                }
                VStack {
                    Button(action: { sequence.timers.append(TimerAction(duration: 10, type: "Training")) },
                           label: { GetButtonLabel(systemImage: "figure.strengthtraining.traditional")
                    })
                    Text((currentLanguage == "English") ?
                         "Training" : "Тренировка")
                }
                VStack {
                    Button(action: { sequence.timers.append(TimerAction(duration: 10, type: "Resting")) },
                           label: { GetButtonLabel(systemImage: "figure.stand")
                    })
                    Text((currentLanguage == "English") ?
                         "Resting" : "Отдых")
                }
            }
            
            List {
                ForEach(0..<sequence.timers.count, id: \.self) { i in
                    VStack {
                        HStack {
                            Image(systemName: actionImages[sequence.timers[i].type] ?? "")
                            Text(((currentLanguage == "English") ? sequence.timers[i].type : typesLocale[sequence.timers[i].type]) ?? "")
                        }
                        
                        HStack {
                            Button(action: { if sequence.timers[i].duration > 0 {
                                sequence.timers[i].duration -= 1
                            }},
                                   label: {
                                Image(systemName: "minus.circle.fill")
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Text(String(sequence.timers[i].duration))
                            Spacer()
                            Button(action: { sequence.timers[i].duration += 1 },
                                   label: {
                                Image(systemName: "plus.circle.fill")
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .foregroundColor(TextColor(color: sequence.color))
                    .listRowBackground(sequence.color)
                }
                .onDelete { indexSet in
                    sequence.timers.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, index in
                    sequence.timers.move(fromOffsets: indexSet, toOffset: index)
                }
            }
            
            Spacer()
            
            Button(action: {
                if sequence.name == "" {
                    sequence.name = (currentLanguage == "English") ? "Timer" : "Таймер"
                }
                
                vm.EditSequence(sequence: sequence)
                
                self.presentationMode.wrappedValue.dismiss()
            },
                   label: {
                Text((currentLanguage == "English") ? "Save" : "Сохранить")
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

