//
//  BattleshipApp.swift
//  Battleship
//
//  Created by Вадим Юрьев on 7.12.22.
//

import SwiftUI
import Firebase

@main
struct BattleshipApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
