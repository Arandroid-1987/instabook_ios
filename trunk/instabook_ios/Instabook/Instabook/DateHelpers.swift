//
//  Data.swift
//  Instabook
//
//  Created by Marco Ferraro on 24/11/16.
//  Copyright © 2016 instabook. All rights reserved.
//

import Foundation



class DateHelper {
    
    internal static func encodeDateForFirebase(date: NSDate) -> NSDictionary
    {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute, .Second, .TimeZone, .Weekday, .Nanosecond], fromDate: date)
        
        let dictionary: NSDictionary = [
            "date" : components.day,
            "day" : components.weekday - 1,
            "hours" : components.hour,
            "minutes" : components.minute,
            "mounth" : components.month - 1,
            "seconds" : components.second,
            "time" : round(date.timeIntervalSince1970 * 1000),
            "timezoneOffset" : -1 * (components.timeZone?.secondsFromGMT)! / 60,
            "year" : components.year - 1900
            
        ]
        
        return dictionary;
    }
    
    
}