//
//  MenuView.swift
//  Battleship
//
//  Created by Вадим Юрьев on 8.12.22.
//

import SwiftUI


struct MenuView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        TabView {
            VStack {
                ProfileView(vm: vm)
                Spacer()
                Divider()
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
            
            VStack {
                StartView()
                Spacer()
                Divider()
            }
            .tabItem {
                Image(systemName: "gamecontroller.fill")
                Text("Game")
            }
            
            VStack {
                Spacer()
                Divider()
            }
            .tabItem {
                Image(systemName: "clock.arrow.circlepath")
                Text("Previous games")
            }
        }
    }
}
