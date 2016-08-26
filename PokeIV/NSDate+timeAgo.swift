//
//  NSDate+timeAgo.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/24/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

extension NSDate {
    public func timeAgo(numericDates: Bool = false) -> String {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        if (components.year >= 2) {
            return String.localizedStringWithFormat(NSLocalizedString("%d years ago", comment: ""), components.year)
        } else if (components.year >= 1){
            if (numericDates){
                return NSLocalizedString("1 year ago", comment: "")
            } else {
                return NSLocalizedString("Last year", comment: "")
            }
        } else if (components.month >= 2) {
            return String.localizedStringWithFormat(NSLocalizedString("%d months ago", comment: ""), components.month)
        } else if (components.month >= 1){
            if (numericDates){
                return NSLocalizedString("1 month ago", comment: "")
            } else {
                return NSLocalizedString("Last month", comment: "")
            }
        } else if (components.weekOfYear >= 2) {
            return String.localizedStringWithFormat(NSLocalizedString("%d weeks ago", comment: ""), components.weekOfYear)
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return NSLocalizedString("1 week ago", comment: "")
            } else {
                return NSLocalizedString("Last week", comment: "")
            }
        } else if (components.day >= 2) {
            return String.localizedStringWithFormat(NSLocalizedString("%d days ago", comment: ""), components.day)
        } else if (components.day >= 1){
            if (numericDates){
                return NSLocalizedString("1 day ago", comment: "")
            } else {
                return NSLocalizedString("Yesterday", comment: "")
            }
        } else if (components.hour >= 2) {
            return String.localizedStringWithFormat(NSLocalizedString("%d hours ago", comment: ""), components.hour)
        } else if (components.hour >= 1){
            if (numericDates){
                return NSLocalizedString("1 hours ago", comment: "")
            } else {
                return NSLocalizedString("An hour ago", comment: "")
            }
        } else if (components.minute >= 2) {
            return String.localizedStringWithFormat(NSLocalizedString("%d minutes ago", comment: ""), components.minute)
        } else if (components.minute >= 1){
            if (numericDates){
                return NSLocalizedString("1 minute ago", comment: "")
            } else {
                return NSLocalizedString("A minute ago", comment: "")
            }
        } else if (components.second >= 3) {
            return String.localizedStringWithFormat(NSLocalizedString("%d seconds ago", comment: ""), components.second)
        } else {
            return NSLocalizedString("Just now", comment: "")
        }
    }
}
