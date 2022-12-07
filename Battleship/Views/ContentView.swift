//
//  ContentView.swift
//  Battleship
//
//  Created by Вадим Юрьев on 7.12.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            VStack {

            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }

            StartView()
            .tabItem {
                Image(systemName: "gamecontroller.fill")
                Text("Game")
            }

            VStack {

            }
            .tabItem {
                Image(systemName: "clock.arrow.circlepath")
                Text("Previous games")
            }
        }
        .preferredColorScheme(.light)
    }
}
