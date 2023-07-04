import SwiftUI

struct Task: Identifiable, Equatable, Hashable, Codable {
    var id = UUID()
    var name: String
    var subtasks: [Subtask]
    var date: Date {
        var date: Date = Date.distantFuture
        for subtask in subtasks {
            if !subtask.isCompleted {
                if subtask.date < date {
                    date = subtask.date
                }
            }
        }
        return date
    }
    
    var hasCompleted: Int {
        var num = 0
        for subtask in subtasks {
            if subtask.isCompleted {
                num += 1
            }
        }
        return num
    }
    
    var isCompleted: Bool {
        return hasCompleted == subtasks.count
    }
    
    var overdue: Int {
        var num = 0
        for subtask in subtasks {
            if !subtask.isCompleted {
                if Date.now > subtask.date {
                    num += 1
                }
            }
        }
        return num
    }
    
    init(_ name: String, subtasks: [Subtask]) {
        self.name = name
        self.subtasks = subtasks
    }
}
