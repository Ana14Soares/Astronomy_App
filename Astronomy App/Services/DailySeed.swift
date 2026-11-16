//
//  DailySeed.swift
//  Astronomy App
//
//  Created by Ana Soares on 12/11/26.
//

import Foundation

struct DailySeed {
    
    private static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    static func seed(for date: Date) -> Int {
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        return year * 10_000 + month * 100 + day
        
    }
    
    static func offset(for date: Date, poolsize: Int) -> Int {
        
        return seed(for: date) % poolsize
        
    }
    
}
