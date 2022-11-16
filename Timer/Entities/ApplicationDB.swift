//
//  ApplicationDB.swift
//  Timer
//
//  Created by Вадим Юрьев on 16.11.22.
//

import SQLite
import Foundation

class ApplicationDB {
    private var db: Connection!
    
    private var timers: Table!
    private var timer_id: Expression<UUID>!
    private var timer_duration: Expression<Int>!
    private var timer_type: Expression<String>!
    private var timer_is_active: Expression<Bool>!
    private var timer_sequence_id: Expression<UUID>!
    
    private var sequences: Table!
    private var sequence_id: Expression<UUID>!
    private var sequence_name: Expression<UUID>!
    private var sequence_color: Expression<String>!
    private var sequence_current_timer: Expression<Int>!
    private var sequence_is_active: Expression<Bool>!
    private var sequence_counter: Expression<Int>!
    
    init(){
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
            sequence_name = Expression<UUID>("sequence_name")
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
        }catch{
            print(error.localizedDescription)
            print(error)
            print(error.self)
        }
    }
}
