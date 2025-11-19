
import Foundation

enum RangeInterval {
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
            comp.day = -0
        case .week:
            comp.day = -0
        case .month:
            comp.month = -0
        case .year:
            comp.year = -0
        case .all:
            comp.year = -0
        }
        let target = cal.date(byAdding: comp, to: now) ?? now
        let startOfDay = cal.startOfDay(for: target)
        return Int(startOfDay.timeIntervalSince1970)
    }
}
