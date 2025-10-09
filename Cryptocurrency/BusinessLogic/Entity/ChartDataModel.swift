//
//  ChartModels.swift
//  Cryptocurrency
//
//  Created by ChatGPT on 07/10/2025.
//

import Foundation

struct ChartPoint {
    let ts: TimeInterval
    let price: Double
}

enum ChartRange {
    case day
    case week
    case month
    case year
    case all

    var toTS: Int {
        let now = Date()
        let cal = Calendar.current
        var comp = DateComponents()
        switch self {
        case .day:
            comp.day = -1
        case .week:
            comp.day = -7
        case .month:
            comp.month = -1
        case .year:
            comp.year = -1
        case .all:
            comp.year = -5
        }
        let target = cal.date(byAdding: comp, to: now) ?? now
        let startOfDay = cal.startOfDay(for: target)
        return Int(startOfDay.timeIntervalSince1970)
    }
}
