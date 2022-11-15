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
}
