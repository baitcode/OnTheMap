//
//  NSDate.swift
//  qlean
//
//  Created by Ilia Batiy on 13/11/15.
//  Copyright © 2015 qlean. All rights reserved.
//

import Foundation


extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    func addTimedelta(days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> NSDate{
        let secondsInMinute: Int = 60
        let secondsInHour: Int = secondsInMinute * 60
        let secondsInDay: Int = secondsInHour * 24

        let secondsInDays : NSTimeInterval = Double(
            days * secondsInDay +
            hours * secondsInHour +
            minutes * secondsInMinute +
            seconds
        )
        
        let alteredDate : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        //Return Result
        return alteredDate
    }
    
    
    func formatted(format:String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    var dateStr : String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.stringFromDate(self)
    }
    
    var dayInMonthString: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "cccc, dd MMMM"
        formatter.locale = NSLocale(localeIdentifier: "ru_RU")
        return formatter.stringFromDate(self)
    }
    
    func toNetworkDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.stringFromDate(self)
    }
    
    func toTitleDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ccc, dd MMMM H:mm"
        formatter.locale = NSLocale(localeIdentifier: "ru_RU")
        return formatter.stringFromDate(self).uppercaseString
    }

}