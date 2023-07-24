import SwiftUI

struct Subtask: Identifiable, Equatable, Hashable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var date: Date
    var isCompleted: Bool
    var isOverdue: Bool {
        if !isCompleted {
            if Date.now > date {
                return true
            }
        }
        return false
    }
    
    init(_ name: String, _ description: String, date: Date = Date(), isCompleted: Bool = false) {
        self.name = name
        self.description = description
        self.date = date
        self.isCompleted = isCompleted
    }
}
