//
//  NSDate+Utility.swift
//  ToDo
//
//  Created by 王荣荣 on 6/23/16.
//  Copyright © 2016 王荣荣. All rights reserved.
//

import UIKit

extension NSDate {
    static func numberOfDaysFromTodayToDate(date: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let date1 = calendar.startOfDayForDate(NSDate())
        let date2 = calendar.startOfDayForDate(date)
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        return components.day
    }
    
    static func hoursAndMinutesBefore(date: NSDate) -> (hours: Int, minutes: Int) {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let date1 = calendar.startOfDayForDate(NSDate())
        let date2 = calendar.startOfDayForDate(date)
        let dayFlags = NSCalendarUnit.Day
        let dayComponents = calendar.components(dayFlags, fromDate: date1, toDate: date2, options: [])
        var hours: Int!
        var minutes: Int!
        if dayComponents.day == 0 {
            let currentHour = calendar.component(NSCalendarUnit.Hour, fromDate: NSDate())
            let hour = calendar.component(NSCalendarUnit.Hour, fromDate: date)
            hours = hour - currentHour
            
            let currentMinutes = calendar.component(NSCalendarUnit.Minute, fromDate: NSDate())
            let tempMinutes = calendar.component(NSCalendarUnit.Minute, fromDate: date)
            minutes = currentMinutes - tempMinutes
        }
        if minutes < 0 {
            minutes =  60 + minutes
            if hours < 0 {
                hours = hours + 1
            } else {
                hours = hours - 1
            }
        }
        return (hours, minutes)
    }
}
