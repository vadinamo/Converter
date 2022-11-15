//
//  Sequence.swift
//  Timer
//
//  Created by Вадим Юрьев on 15.11.22.
//

import Foundation

struct Sequence {
    var id: UUID = UUID()
    var name: String = ""
    var color: String = ""
    var timers: [TimerAction] = []
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
}
