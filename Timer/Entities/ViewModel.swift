//
//  ViewModel.swift
//  Timer
//
//  Created by Вадим Юрьев on 15.11.22.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published public var sequences: [Sequence]
    
    init() {
        self.sequences = ApplicationDB().GetSequences()
    }
    
    func AddSequence(sequence: Sequence) {
        ApplicationDB().AddSequence(sequence: sequence)
        self.sequences = ApplicationDB().GetSequences()
    }
    
    func EditSequence(sequence: Sequence) {
        if let i = sequences.firstIndex(where: {$0.id == sequence.id}) {
            sequences[i] = sequence
            reset(id: sequence.id)
        }
    }
    
    func RemoveSequence(sequence: Sequence) {
        ApplicationDB().SequenceDelete(sequenceId: sequence.id)
        self.sequences = ApplicationDB().GetSequences()
    }
    
    func sequence(id: UUID) -> Sequence {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            return sequences[i]
        }
        
        return Sequence(name: "", color: Color.Accent, timers: [])
    }
    
    func tick(id: UUID) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            if sequences[i].currentTimer == 0 && sequences[i].timers[0].isActive == false {
                sequences[i].timers[0].isActive = true
            }
            if sequences[i].timers[sequences[i].currentTimer].duration > sequences[i].counter {
                sequences[i].counter += 1
            }
            else {
                if sequences[i].currentTimer < sequences[i].timers.count - 1 {
                    sequences[i].counter = 0
                    sequences[i].timers[sequences[i].currentTimer].isActive = false
                    sequences[i].currentTimer += 1
                    sequences[i].timers[sequences[i].currentTimer].isActive = true
                }
                else {
                    reset(id: id)
                }
            }
        }
    }
    
    func changeTimer(id: UUID, newTimer: Int) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            sequences[i].timers[sequences[i].currentTimer].isActive = false
            sequences[i].currentTimer = newTimer
            sequences[i].timers[newTimer].isActive = true
            sequences[i].counter = 0
        }
    }
    
    func toggle(id: UUID) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            sequences[i].isActive.toggle()
        }
    }
    
    func reset(id: UUID) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            sequences[i].timers[sequences[i].currentTimer].isActive = false
            sequences[i].isActive = false
            sequences[i].currentTimer = 0
            sequences[i].counter = 0
        }
    }
}
