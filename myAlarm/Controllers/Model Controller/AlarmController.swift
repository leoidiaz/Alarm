//
//  AlarmController.swift
//  myAlarm
//
//  Created by Leonardo Diaz on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import Foundation

class AlarmController {
    
    //MARK: - Singleton
    static let shared = AlarmController()
    
    //MARK: - Source of Truth
    var alarms = [Alarm]()
    
    //MARK: - Mock Data
    var mockAlarms: [Alarm] = {
        return [Alarm(fireDate: Date(), name: "Good Afternoon", enabled: true),
                Alarm(fireDate: Date(), name: "Good Afternoon2", enabled: false)]
    }()
    
    init() {
        self.alarms = self.mockAlarms
    }
    //MARK: - CRUD
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool){
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        //Save
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        //Save
    }
    
    func delete(alarm: Alarm){
        guard let indexPath = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: indexPath)
        //Save
    }
    
    func toggleEnabled(for alarm: Alarm){
        alarm.enabled = !alarm.enabled
    }
}
