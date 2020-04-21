//
//  AlarmController.swift
//  myAlarm
//
//  Created by Leonardo Diaz on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

protocol AlarmSchedulerDelegate: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

class AlarmController {
    
    //MARK: - Singleton
    static let shared = AlarmController()
    
    //MARK: - Source of Truth
    var alarms = [Alarm]()
    
    /// Conform to delegate
    weak var delegate: AlarmSchedulerDelegate?
    
    //MARK: - Mock Data
//    var mockAlarms: [Alarm] = {
//        return [Alarm(fireDate: Date(), name: "Good Afternoon", enabled: true),
//                Alarm(fireDate: Date(), name: "Good Afternoon2", enabled: false)]
//    }()
    
//    init() {
//        self.alarms = self.mockAlarms
//    }
    //MARK: - CRUD
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool){
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        delegate?.scheduleUserNotifications(for: newAlarm)
        saveForPersistence()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        if alarm.enabled {
            delegate?.scheduleUserNotifications(for: alarm)
        } else {
            delegate?.cancelUserNotifications(for: alarm)
        }
        saveForPersistence()
    }
    
    func delete(alarm: Alarm){
        guard let indexPath = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: indexPath)
        delegate?.cancelUserNotifications(for: alarm)
        saveForPersistence()
    }
    
    func toggleEnabled(for alarm: Alarm){
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            delegate?.scheduleUserNotifications(for: alarm)
        } else {
            delegate?.cancelUserNotifications(for: alarm)
        }
        
    }
    
    //MARK: - Persistence
    
    func createFileForPersistentStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("myAlarm.json")
        return fileURL
    }
    
    
    func saveForPersistence() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: createFileForPersistentStore())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadFromPersistence() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: createFileForPersistentStore())
            let decodedData = try decoder.decode([Alarm].self, from: data)
            alarms = decodedData
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension AlarmSchedulerDelegate {
    func scheduleUserNotifications(for alarm: Alarm){
        //Create notifcationContent
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "TIME IS UP"
        notificationContent.body = alarm.name
        notificationContent.sound = .default
        // Create date Component
        let fireDate = alarm.fireDate
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: fireDate)
        // Create Notification Trigger
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        // Create notification Request
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
