//
//  ViewModel.swift
//  Timer
//
//  Created by Вадим Юрьев on 15.11.22.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published public var sequences: [Sequence]
    @AppStorage("currentLanguage") private var currentLanguage = "English"
    @AppStorage("onNotification") private var onNotification = false
    
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
            ApplicationDB().SequenceUpdate(sequence: sequences[i])
            self.sequences = ApplicationDB().GetSequences()
        }
    }
    
    func RemoveSequence(sequence: Sequence) {
        ApplicationDB().SequenceDelete(sequence: sequence)
        self.sequences = ApplicationDB().GetSequences()
    }
    
    func MoveSequence(indexSet: IndexSet, index: Int) {
        self.sequences.move(fromOffsets: indexSet, toOffset: index)
        ApplicationDB().hardUpdate(sequences: sequences)
        self.sequences = ApplicationDB().GetSequences()
    }
    
    func Clear() {
        ApplicationDB().clear()
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
            ApplicationDB().SequenceUpdate(sequence: sequence(id: id))
            self.sequences = ApplicationDB().GetSequences()
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
            for j in sequences {
                if j.id != sequences[i].id {
                    reset(id: j.id)
                }
            }
            sequences[i].isActive.toggle()
            ApplicationDB().SequenceUpdate(sequence: sequence(id: id))
            self.sequences = ApplicationDB().GetSequences()
        }
    }
    
    func reset(id: UUID) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            if sequences[i].timers.count != 0 {
                sequences[i].timers[sequences[i].currentTimer].isActive = false
            }
            onNotification = false
            sequences[i].isActive = false
            sequences[i].currentTimer = 0
            sequences[i].counter = 0
            
            ApplicationDB().hardUpdate(sequences: sequences)
            self.sequences = ApplicationDB().GetSequences()
        }
    }
    
    func AddBackground(id: UUID, timeSpent: Int) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            var counter = timeSpent
            
            for _ in sequences[i].currentTimer..<sequences[i].timers.count {
                if counter > (sequences[i].timers[sequences[i].currentTimer].duration - sequences[i].counter) {
                    counter -= (sequences[i].timers[sequences[i].currentTimer].duration - sequences[i].counter)
                    
                    sequences[i].timers[sequences[i].currentTimer].isActive = false
                    sequences[i].currentTimer += 1
                    
                    if sequences[i].currentTimer == sequences[i].timers.count {
                        sequences[i].currentTimer -= 1
                        reset(id: sequences[i].id)
                        ApplicationDB().SequenceUpdate(sequence: sequences[i])
                        self.sequences = ApplicationDB().GetSequences()
                        return
                    }
                    
                    sequences[i].timers[sequences[i].currentTimer].isActive = true
                    
                    sequences[i].counter = 0
                    ApplicationDB().SequenceUpdate(sequence: sequences[i])
                    self.sequences = ApplicationDB().GetSequences()
                }
                else {
                    sequences[i].counter += counter
                    ApplicationDB().SequenceUpdate(sequence: sequences[i])
                    self.sequences = ApplicationDB().GetSequences()
                    return
                }
            }
        }
    }
    
    func AddNotifications(id: UUID) {
        if let i = sequences.firstIndex(where: {$0.id == id}) {
            var count = sequences[i].timers[sequences[i].currentTimer].duration - sequences[i].counter
            var next_type = ""
            var next_duration = 0
            
            if sequences[i].currentTimer + 1 < sequences[i].timers.count {
                next_type = sequences[i].timers[sequences[i].currentTimer + 1].type
                next_duration = sequences[i].timers[sequences[i].currentTimer + 1].duration
            }
            
            AddNotification(current_duration: count, next_duration: next_duration, current_type: sequences[i].timers[sequences[i].currentTimer].type, next_type: next_type)
            
            for j in sequences[i].currentTimer + 1..<sequences[i].timers.count {
                count += sequences[i].timers[j].duration
                next_type = ""
                next_duration = 0
                
                if j < sequences[i].timers.count - 1 {
                    next_type = sequences[i].timers[j + 1].type
                    next_duration = sequences[i].timers[j + 1].duration
                }
                
                AddNotification(current_duration: count, next_duration: next_duration, current_type: sequences[i].timers[j].type, next_type: next_type)
            }
        }
    }
    
    private func AddNotification(current_duration: Int, next_duration: Int, current_type: String, next_type: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = (currentLanguage == "English") ? "Timer" : "Таймер"
        
        if next_type != "" {
            notificationContent.body =  (currentLanguage == "English") ? "End of \"\(current_type)\", begin of \"\(next_type)\" (\(next_duration) s)" :
            "Конец \"\(typesLocale[current_type] ?? "")\", начало \"\(typesLocale[next_type] ?? "")\" (\(next_duration) с)"
        }
        else {
            notificationContent.body =  (currentLanguage == "English") ? "End of \"\(current_type)\", training is over" :
            "Конец \"\(typesLocale[current_type] ?? "")\", тренировка закончена"
        }
        
        notificationContent.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(current_duration), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func RemoveNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
