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
    
    static func seed(for components: DateComponents) -> Int? {
        guard let year = components.year,
              let month = components.month,
              let day = components.day else { return nil }

        return year * 10_000 + month * 100 + day
    }
    
    static func offset(forSeed seed: Int, poolsize: Int) -> Int {
        
        var x = UInt64(seed)
            x = (x ^ (x >> 30)) &* 0xbf58476d1ce4e5b9
            x = (x ^ (x >> 27)) &* 0x94d049bb133111eb
            x = x ^ (x >> 31)
            return Int(x % UInt64(poolsize))
        
    }
    
    static func components(fromSeed seed: Int) -> DateComponents {
        DateComponents(
            year: seed / 10000,
            month: (seed / 100) % 100,
            day: seed % 100
        )
    }
    
}
