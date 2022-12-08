//
//  StartView.swift
//  Battleship
//
//  Created by Вадим Юрьев on 7.12.22.
//

import SwiftUI


struct StartView: View {
    @State var code: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Join game")
                    .font(.largeTitle)
                TextField("Invite code", text: $code)
                NavigationLink {
                    GameView()
                } label: {
                    HStack {
                        Spacer()
                        Text("Join")
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Divider()
                
                Text("Create game")
                    .font(.largeTitle)
                Button(action: {
                }, label: {
                    Spacer()
                    Text("Create")
                    Spacer()
                })
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
