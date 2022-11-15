//
//  Sequence.swift
//  Timer
//
//  Created by Вадим Юрьев on 15.11.22.
//

import Foundation
import SwiftUI

struct Sequence: Hashable {
    var id: UUID = UUID()
    var name: String
    var color: Color
    var timers: [TimerAction]
    
    var currentTimer: Int
    var isActive: Bool
    var counter: Int
    
    init(name: String, color: Color, timers: [TimerAction]) {
        self.name = name
        self.color = color
        self.timers = timers
        
        self.currentTimer = 0
        self.isActive = false
        self.counter = 0
    }
    
    func totalTime() -> String {
        var seconds = timers.map {$0.duration}.reduce(0, +)
        
        let hours = seconds / 3600
        let minutes = (seconds - hours * 3600) / 60
        seconds -= hours * 3600 + minutes * 60
        
        var minutesStr = String(minutes)
        if minutesStr.count == 1 {
            minutesStr = "0" + minutesStr
        }
        
        var secondsStr = String(seconds)
        if secondsStr.count == 1 {
            secondsStr = "0" + secondsStr
        }
        
        return "\(hours):\(minutesStr):\(secondsStr)"
    }
}
