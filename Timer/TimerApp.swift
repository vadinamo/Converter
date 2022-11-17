//
//  TimerApp.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import SwiftUI

@main
struct TimerApp: App {
    init() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("error: \(error)")
            } else {
                print("success")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: ViewModel())
        }
    }
}
