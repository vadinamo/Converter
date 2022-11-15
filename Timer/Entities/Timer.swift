//
//  Timer.swift
//  Timer
//
//  Created by Вадим Юрьев on 14.11.22.
//

import Foundation

struct TimerAction: Identifiable {
    var id: UUID = UUID()
    var duration: Int = 0
    var type: String = ""
    private var isStarted: Bool = false
    
    init(duration: Int, type: String) {
        self.duration = duration
        self.type = type
        self.isStarted = false
    }
}
