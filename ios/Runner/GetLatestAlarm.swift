//
//  GetLatestAlarm.swift
//  Runner
//
//  Created by Kush Choudhary on 04/03/25.
//
import FMDB
import Foundation

public func getLatestAlarm(db: FMDatabase?, profile: String) -> [String: Any]? {
    let query =
        """
        SELECT * FROM alarms
        WHERE isEnabled = 1
        AND (profile = ? OR ringOn = 1)
        """
    
    guard let resultSet = db?.executeQuery(query, withArgumentsIn: [profile]) else {
        NSLog("Log:ERROR while executing database query.")
        return nil
    }
    
    var selectedAlarm: AlarmModel?
    var minInterval: Double = .greatestFiniteMagnitude
    
    while resultSet.next() {
        let alarm = AlarmModel(
            id: Int(resultSet.int(forColumn: "id")),
            minutesSinceMidnight: Int(resultSet.int(forColumn: "minutesSinceMidnight")),
            alarmTime: resultSet.string(forColumn: "alarmTime") ?? "",
            days: resultSet.string(forColumn: "days") ?? "0000000",
            isOneTime: resultSet.bool(forColumn: "isOneTime"),
            activityMonitor: resultSet.bool(forColumn: "activityMonitor"),
            isWeatherEnabled: resultSet.bool(forColumn: "isWeatherEnabled"),
            weatherTypes: resultSet.string(forColumn: "weatherTypes") ?? "",
            isLocationEnabled: resultSet.bool(forColumn: "isLocationEnabled"),
            location: resultSet.string(forColumn: "location") ?? "",
            alarmDate: resultSet.string(forColumn: "alarmDate") ?? "",
            alarmId: resultSet.string(forColumn: "alarmID") ?? "",
            ringOn: resultSet.bool(forColumn: "ringOn")
        )
        
        var timeDiff = getTimeDifference(alarmTime: alarm.alarmTime)
        if timeDiff <= 0 {
            timeDiff = Double(24*60*60) + timeDiff
        }
        if timeDiff > 0, timeDiff < minInterval {
            minInterval = timeDiff
            selectedAlarm = alarm
        }
    }
    
    NSLog("Log:Alarm: \(minInterval)")
    guard let finalAlarm = selectedAlarm else { return nil }
    return [
        "interval": minInterval,
        "isActivity": finalAlarm.activityMonitor,
        "isLocation": finalAlarm.isLocationEnabled,
        "location": finalAlarm.location,
        "isWeather": finalAlarm.isWeatherEnabled,
        "weatherTypes": finalAlarm.weatherTypes,
        "alarmID": finalAlarm.alarmId
    ]
}

private func getTimeDifference(alarmTime: String) -> Double {
    NSLog("Log:FROM DB ALARMTIME: \(alarmTime)")
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures correct parsing
    
    let curr = Date()
    
    guard let alarm = formatter.date(from: alarmTime) else {
        NSLog("Error: Invalid alarmTime format")
        return -1
    }
    
    let calendar = Calendar.current
    
    // Normalize `curr` to only HH:mm
    let currComponents = calendar.dateComponents([.hour, .minute], from: curr)
    let currSecComponent = calendar.dateComponents([.second], from: curr)
    let normalizedCurr = calendar.date(from: currComponents)!
    
    // Normalize `alarm` to only HH:mm
    let alarmComponents = calendar.dateComponents([.hour, .minute], from: alarm)
    guard let normalizedAlarm = calendar.date(from: alarmComponents) else {
        NSLog("Error: Failed to normalize alarm time")
        return -1
    }
    
    NSLog("Log:Curr: \(formatter.string(from: normalizedCurr)) seconds: \(currSecComponent.second)")
    NSLog("Log:AlarmTime: \(formatter.string(from: normalizedAlarm))")
    
    // Compute time difference
    let diff = calendar.dateComponents([.hour, .minute], from: normalizedCurr, to: normalizedAlarm)
    
    NSLog("Log:Hour: \(diff.hour ?? 0)")
    NSLog("Log:Minute: \(diff.minute ?? 0)")
    
    let hours = diff.hour ?? 0
    let minutes = diff.minute ?? 0
    let secondsToReduce = currSecComponent.second ?? 0

    let totalSeconds: Double = Double((hours * 60 * 60) + (minutes * 60) - (secondsToReduce))
    
    return totalSeconds
}
