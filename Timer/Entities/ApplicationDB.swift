//
//  ApplicationDB.swift
//  Timer
//
//  Created by Вадим Юрьев on 16.11.22.
//

import SQLite
import SwiftUI
import Foundation

class ApplicationDB {
    private var db: Connection!
    
    private var timers: SQLite.Table!
    private var timer_id: Expression<UUID>!
    private var timer_duration: Expression<Int>!
    private var timer_type: Expression<String>!
    private var timer_is_active: Expression<Bool>!
    private var timer_sequence_id: Expression<UUID>!
    
    private var sequences: SQLite.Table!
    private var sequence_id: Expression<UUID>!
    private var sequence_name: Expression<String>!
    private var sequence_color: Expression<String>!
    private var sequence_current_timer: Expression<Int>!
    private var sequence_is_active: Expression<Bool>!
    private var sequence_counter: Expression<Int>!
    
    init() {
        do{
            db = try Connection("\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")/db1.sqlite3")
            
            timers = Table("timers")
            timer_id = Expression<UUID>("timer_id")
            timer_duration = Expression<Int>("timer_duration")
            timer_type = Expression<String>("timer_type")
            timer_is_active = Expression<Bool>("timer_is_active")
            timer_sequence_id = Expression<UUID>("timer_sequence_id")
            
            sequences = Table("sequences")
            sequence_id = Expression<UUID>("sequence_id")
            sequence_name = Expression<String>("sequence_name")
            sequence_color = Expression<String>("sequence_color")
            sequence_current_timer = Expression<Int>("sequence_current_timer")
            sequence_is_active = Expression<Bool>("sequence_is_active")
            sequence_counter = Expression<Int>("sequence_counter")
            
            if(!UserDefaults.standard.bool(forKey: "db_created")) {
                try db.run(timers.create{ (table) in
                    table.column(timer_id, primaryKey: true)
                    table.column(timer_duration)
                    table.column(timer_type)
                    table.column(timer_is_active)
                    table.column(timer_sequence_id)
                })
                
                try db.run(sequences.create{ (table) in
                    table.column(sequence_id, primaryKey: true)
                    table.column(sequence_name)
                    table.column(sequence_color)
                    table.column(sequence_current_timer)
                    table.column(sequence_is_active)
                    table.column(sequence_counter)
                })
                
                UserDefaults.standard.set(true, forKey: "db_created")
            }
        } catch {
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
    }
    
    public func AddSequence(sequence: Sequence) {
        do {
            for timer in sequence.timers {
                try db.run(timers.insert(timer_id <- timer.id,
                                         timer_duration <- timer.duration,
                                         timer_type <- timer.type,
                                         timer_is_active <- timer.isActive,
                                         timer_sequence_id <- sequence.id))
            }
            print(colorToString(color: UIColor(sequence.color)))
            try db.run(sequences.insert(sequence_id <- sequence.id,
                                        sequence_name <- sequence.name,
                                        sequence_color <- colorToString(color: UIColor(sequence.color)),
                                        sequence_current_timer <- sequence.currentTimer,
                                        sequence_is_active <- sequence.isActive,
                                        sequence_counter <- sequence.counter))
        } catch {
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
    }
    
    public func GetSequences() -> [Sequence] {
        var sequencesToGet: [Sequence] = []
        
        do {
            for sequence in try db.prepare(sequences) {
                var newSequence: Sequence = Sequence(
                    name: sequence[sequence_name],
                    color: Color(stringToColor(string: sequence[sequence_color])),
                    timers: [])
                
                newSequence.id = sequence[sequence_id]
                newSequence.currentTimer = sequence[sequence_current_timer]
                newSequence.isActive = sequence[sequence_is_active]
                newSequence.counter = sequence[sequence_counter]
                newSequence.timers = GetTimers(sequenceId: sequence[sequence_id])
                
                sequencesToGet.append(newSequence)
            }
        } catch {
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
        
        return sequencesToGet
    }
    
    public func GetTimers(sequenceId: UUID) -> [TimerAction] {
        var timersToGet: [TimerAction] = []
        
        do {
            for timer in try db.prepare(timers) {
                if timer[timer_sequence_id] == sequenceId {
                    var newTimer: TimerAction = TimerAction(
                        duration: timer[timer_duration],
                        type: timer[timer_type]
                    )
                    
                    newTimer.id = timer[timer_id]
                    newTimer.isActive = timer[timer_is_active]
                    
                    timersToGet.append(newTimer)
                }
            }
        } catch {
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
        
        return timersToGet
    }
    
    public func SequenceDelete(sequence: Sequence) {
        do {
            let sequenceToDelete = sequences.filter(sequence_id == sequence.id)
            try db.run(sequenceToDelete.delete())
            
            for _ in 0..<sequence.timers.count {
                TimerDelete(sequenceId: sequence.id)
            }
        } catch {
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
    }
    
    public func TimerDelete(sequenceId: UUID) {
        do {
            let timerToDelete = timers.filter(timer_sequence_id == sequenceId)
            try db.run(timerToDelete.delete())
        } catch {
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
    }
    
    public func SequenceUpdate(sequence: Sequence) {
        do {
            let sequenceToUpdate: SQLite.Table = sequences.filter(sequence_id == sequence.id)
            try db.run(sequenceToUpdate.update(sequence_id <- sequence.id,
                                               sequence_name <- sequence.name,
                                               sequence_color <- colorToString(color: UIColor(sequence.color)),
                                               sequence_current_timer <- sequence.currentTimer,
                                               sequence_is_active <- sequence.isActive,
                                               sequence_counter <- sequence.counter))
            for _ in 0..<sequence.timers.count {
                TimerDelete(sequenceId: sequence.id)
            }
            for timer in sequence.timers {
                try db.run(timers.insert(timer_id <- timer.id,
                                         timer_duration <- timer.duration,
                                         timer_type <- timer.type,
                                         timer_is_active <- timer.isActive,
                                         timer_sequence_id <- sequence.id))
            }
        } catch {
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
    }
    
    func colorToString(color: UIColor) -> String {
        let components = color.cgColor.components
        return "[\(components![0]), \(components![1]), \(components![2]), \(components![3])]"
    }
    
    func stringToColor(string: String) -> UIColor {
        let componentsString = string.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        let components = NSString(string: componentsString).components(separatedBy: ", ")
        return UIColor(red: CGFloat((components[0] as NSString).floatValue),
                       green: CGFloat((components[1] as NSString).floatValue),
                       blue: CGFloat((components[2] as NSString).floatValue),
                       alpha: CGFloat((components[3] as NSString).floatValue))
    }
    
    public func hardUpdate(sequences: [Sequence]) {
        clear()
        for sequence in sequences {
            AddSequence(sequence: sequence)
        }
    }
    
    public func clear() {
        do {
            try db.run(timers.delete())
            try db.run(sequences.delete())
        } catch {
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
    }
}
