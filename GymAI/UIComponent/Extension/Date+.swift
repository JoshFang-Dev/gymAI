//
//  Date+.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-08-08.
//

import SwiftUI

extension Date{
    func toDateString() -> String
    {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "E, MMM d"
        //    inputFormatter.locale = Locale(identifier: "en_US")
        return inputFormatter.string(from: self)
        
    }
    func getDateOnly()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
    
    
    
    func getAllWeekDay() -> [Date]{
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        let dayOfWeek = calendar.component(.weekday, from: today)
        let days = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
//            .filter { !calendar.isDateInWeekend($0) }
        return days
    }
}

extension String{
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
//        let isoDate = "2016-04-14T10:44:00+0000"
//        2022-08-09 07:45:56 +0000
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
          let date = dateFormatter.date(from:self)!
        return date
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
