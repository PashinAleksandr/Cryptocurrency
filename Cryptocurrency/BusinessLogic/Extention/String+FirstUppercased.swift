
import Foundation

extension String {
    func firstUppercased() -> String {
        guard let first = self.first else { return self }
        return String(first).uppercased() + self.dropFirst()
    }
}

extension String {
    static let home = "главная"
    static let all = "All"
    static let week = "Week"
    static let year = "year"
}

