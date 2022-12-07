//
//  GameView.swift
//  Battleship
//
//  Created by Вадим Юрьев on 7.12.22.
//

import SwiftUI


struct GameView: View {
    @State private var surrender: Bool = false
    @State var confirmationShown = false
    
    var field: [[Int]] = [
        [1, 0, 1, 0, 1, 0, 1, 0, 0, 0],
        [0, 1, 0, 0, 1, 0, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
        [0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
        [1, 0, 0, 1, 0, 0, 0, 0, 0, 0],
        [1, 0, 1, 1, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 1, 0, 0, 0, 0, 0, 0],
        [1, 0, 0, 1, 0, 0, 0, 0, 0, 0]]
    
    @State var attacks: [[Int]] = [ // 0 - none, 1 - hit, 2 - miss
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
    
    @State var text: String = "1"
    var letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    
    func symbol(_ s: Int) -> String {
        if s == 0 {
            return " "
        }
        else if s == 1 {
            return "X"
        }
        
        return "."
    }
    
    var body: some View {
        VStack {
            if !surrender {
                HStack {
                    Button(action: {
                        confirmationShown = true
                    }, label: {
                        Image(systemName: "flag.fill")
                        Text("Surrender")
                    })
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
            VStack {
                ForEach(0...9, id: \.self) {i in
                    HStack {
                        ForEach(0...9, id: \.self) { j in
                            VStack {
                                ZoneView(currentState: attacks[i][j], size: 30)
                                    .onTapGesture {
                                        if attacks[i][j] == 0 {
                                            attacks[i][j] = (field[i][j] == 1) ? 1 : 2
                                        }
                                    }
                            }
                        }
                    }
                }
                
                Divider()
                
                ForEach(0...9, id: \.self) {i in
                    HStack {
                        ForEach(0...9, id: \.self) { j in
                            VStack {
                                ZoneView(currentState: attacks[i][j], size: 15)
                            }
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(!surrender)
        }
        .padding()
        .swipeActions {
            Button(
                role: .destructive,
                action: { confirmationShown = true }
            ) {
                Image(systemName: "trash")
            }
        }
        .confirmationDialog(
            "Are you sure?",
            isPresented: $confirmationShown
        ) {
            Button("Yes", role: .destructive) {
                surrender = true
            }
        }
    }
}
