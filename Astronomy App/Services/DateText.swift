//
//  DataText.swift
//  Astronomy App
//
//  Created by Ana Soares on 17/11/26.
//

import Foundation

enum DateText {
    private static let parser = ISO8601DateFormatter()
    
    private static let display: DateFormatter = {
        let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                return formatter
    }()
    
    static func short(fromSeed seed: Int) -> String {
        let components = DailySeed.components(fromSeed: seed)
        guard let date = Calendar.current.date(from: components) else { return "" }
        return display.string(from: date)
    }
    
    static func title(forSeed seed: Int) -> String {
        if seed == DailySeed.seed(for: Date()) {
                return "Today"
            }
            return short(fromSeed: seed)
    }
    
}
