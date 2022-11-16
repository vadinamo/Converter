//
//  SequenceView.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI

struct SequenceView: View {
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    @AppStorage("currentFontSize") private var currentFontSize = "Small"
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        NewSequenceView(vm: vm)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .font(.system(size: CGFloat(fontSizes[currentFontSize] ?? 0)))
                
                Text((currentLanguage == "English") ?
                     "Sequences" : "Последовательности").fontWeight(.bold)
                
                List {
                    ForEach(0..<vm.sequences.count, id: \.self) { i in
                        NavigationLink{ SequenceItemView(vm: vm, sequenceId: vm.sequences[i].id) } label: {
                            HStack{
                                Text(vm.sequences[i].name).bold()
                                
                                Spacer()
                                
                                Text(vm.sequences[i].totalTime())
                                
                                Spacer()
                                
                                Button(action: {
                                    vm.RemoveSequence(sequence: vm.sequences[i])
                                }, label: {
                                    Image(systemName: "trash.fill")
                                    
                                })
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .foregroundColor(TextColor(color: vm.sequences[i].color))
                        .listRowBackground(vm.sequences[i].color)
                        .padding()
                    }
                    .onMove { indexSet, index in
                        vm.sequences.move(fromOffsets: indexSet, toOffset: index)
                    }
                }
                
                Spacer()
                Divider()
            }
            .padding()
        }
    }
}
