//
//  TimerApp.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI

@main
struct TimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(vm: ViewModel())
        }
    }
}
