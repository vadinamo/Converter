//
//  SequenceItemView.swift
//  Timer
//
//  Created by Вадим Юрьев on 15.11.22.
//

import SwiftUI
import AVFoundation

struct SequenceItemView: View {
    @AppStorage("currentFontSize") private var currentFontSize = "Small"
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    @AppStorage("darkMode") private var darkMode = false
    
    @ObservedObject var vm: ViewModel
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var to: CGFloat = 1
    
    let sequenceId: UUID
    
    var body: some View {
        VStack {
            if !vm.sequence(id: sequenceId).isActive {
                NavigationLink {
                    EditSequenceView(vm: vm, sequence: vm.sequence(id: sequenceId))
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "square.and.pencil.circle.fill")
                    }
                }
            }
            
            Text(vm.sequence(id: sequenceId).name).bold()
            
            if vm.sequence(id: sequenceId).timers.count > 0 {
                ZStack {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(TextColor(color: darkMode ? Color.black : Color.white).opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round))
                            .frame(width: 280, height: 280)
                        Circle()
                            .trim(from: 0, to: self.to)
                            .stroke(vm.sequence(id: sequenceId).color, style: StrokeStyle(lineWidth: 35, lineCap: .round))
                            .frame(width: 280, height: 280)
                    }
                    .rotationEffect(.init(degrees: -90))
                    
                    VStack {
                        Text("\(vm.sequence(id: sequenceId).timers[vm.sequence(id: sequenceId).currentTimer].duration - vm.sequence(id: sequenceId).counter)")
                            .font(.system(size: 65))
                            .bold()
                        Text("\((currentLanguage == "English") ? "of " : "из ")\(vm.sequence(id: sequenceId).timers[vm.sequence(id: sequenceId).currentTimer].duration)")
                    }
                }
                .padding()
                
                HStack {
                    Button(action: {
                        vm.toggle(id: sequenceId)
                    }, label: {
                        ZStack {
                            Circle().frame(width: CGFloat((fontSizes[currentFontSize] ?? 0) * 2), height: CGFloat((fontSizes[currentFontSize] ?? 0) * 2))
                                .foregroundColor(vm.sequence(id: sequenceId).color)
                            Image(systemName: vm.sequence(id: sequenceId).isActive ? "pause.fill" : "play.fill")
                                .foregroundColor(TextColor(color: vm.sequence(id: sequenceId).color))
                        }
                    })
                    
                    Button(action: {
                        vm.reset(id: sequenceId)
                        withAnimation(.default) {
                            self.to = 0
                        }
                    }, label: {
                        ZStack {
                            Circle().frame(width: CGFloat((fontSizes[currentFontSize] ?? 0) * 2), height: CGFloat((fontSizes[currentFontSize] ?? 0) * 2))
                                .foregroundColor(vm.sequence(id: sequenceId).color)
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(TextColor(color: vm.sequence(id: sequenceId).color))
                        }
                    })
                }
                .padding()
            }
            else {
                Spacer()
                Text("\((currentLanguage == "English") ? "There is no timers in \(vm.sequence(id: sequenceId).name) add some to start" : "Еще нет таймеров в последовательности '\(vm.sequence(id: sequenceId).name)' добавьте несколько для начала")").padding()
            }
            
            List {
                ForEach(0..<vm.sequence(id: sequenceId).timers.count, id: \.self) { i in
                    Button(action: { vm.changeTimer(id: sequenceId, newTimer: i) }, label: {
                        HStack {
                            Image(systemName: actionImages[vm.sequence(id: sequenceId).timers[i].type] ?? "")
                            Spacer()
                            if vm.sequence(id: sequenceId).timers[i].isActive {
                                Image(systemName: "play.fill")
                            }
                            Text(((currentLanguage == "English") ? vm.sequence(id: sequenceId).timers[i].type : typesLocale[vm.sequence(id: sequenceId).timers[i].type]) ?? "")
                            Spacer()
                            Text("\(vm.sequence(id: sequenceId).timers[i].duration) \((currentLanguage == "English") ? "s" : "с")")
                        }
                    })
                }
                .foregroundColor(TextColor(color: vm.sequence(id: sequenceId).color))
                .listRowBackground(vm.sequence(id: sequenceId).color)
            }
        }
        .padding()
        .onReceive(self.time, perform: { (_) in
            if vm.sequence(id: sequenceId).isActive {
                if vm.sequence(id: sequenceId).isActive && vm.sequence(id: sequenceId).timers[vm.sequence(id: sequenceId).currentTimer].duration - vm.sequence(id: sequenceId).counter <= 4 && vm.sequence(id: sequenceId).timers[vm.sequence(id: sequenceId).currentTimer].duration - vm.sequence(id: sequenceId).counter > 0 {
                    let systemSoundID: SystemSoundID = 1052
                    AudioServicesPlaySystemSound(systemSoundID)
                }
                vm.tick(id: sequenceId)
                withAnimation(.default) {
                    self.to = 1 - CGFloat(vm.sequence(id: sequenceId).counter) / CGFloat(vm.sequence(id: sequenceId).timers[vm.sequence(id: sequenceId).currentTimer].duration)
                }
            }
            print(vm.sequence(id: sequenceId).counter)
        })
    }
}
