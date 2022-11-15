//
//  ViewModel.swift
//  Timer
//
//  Created by Вадим Юрьев on 15.11.22.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var sequences: [Sequence]
    
    init() {
        self.sequences = []
    }
    
    func EditSequence(sequence: Sequence) {
        if let i = sequences.firstIndex(where: {$0.id == sequence.id}) {
            sequences[i] = sequence
        }
    }
    
    func sequence(id: UUID) -> Sequence {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            return sequences[i]
        }
        
        return Sequence(name: "", color: Color.Accent, timers: [])
    }
    
    func tick(id: UUID) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            if sequences[i].timers[sequences[i].currentTimer].duration > sequences[i].counter {
                sequences[i].counter += 1
            }
            else {
                if sequences[i].currentTimer < sequences[i].timers.count - 1 {
                    sequences[i].counter = 0
                    sequences[i].currentTimer += 1
                }
                else {
                    sequences[i].isActive = false
                }
            }
        }
    }
    
    func toggle(id: UUID) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            sequences[i].isActive.toggle()
        }
    }
    
    func reset(id: UUID) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            sequences[i].currentTimer = 0
            sequences[i].isActive = false
            sequences[i].counter = 0
        }
    }
}
