import SwiftUI

class DataManager: ObservableObject {
    @Published var data: [Task] = [Task("示例任务", subtasks: [Subtask("子任务", "这是一个子任务。")])]
    
    var finishedSubtasks: Int {
        var num = 0
        for task in self.data {
            num += task.hasCompleted
        }
        return num
    }
    
    var totalSubtasks: Int {
        var num = 0
        for task in self.data {
            num += task.subtasks.count
        }
        return num
    }
    
    init() {
        setup()
    }
        
    private static func getDataFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("TaskData.json")
    }
    
    func load() {
        do {
            let fileURL = try DataManager.getDataFileURL()
            let fileData = try Data(contentsOf: fileURL)
            data = try JSONDecoder().decode([Task].self, from: fileData)
        } catch {
            print("Failed to load.")
        }
    }
    
    func save() {
        do {
            let fileURL = try DataManager.getDataFileURL()
            let fileData = try JSONEncoder().encode(data)
            try fileData.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save.")
        }
    }
    
    func setup() {
        do {
            let fileURL = try DataManager.getDataFileURL()
            let fileData = try Data(contentsOf: fileURL)
            data = try JSONDecoder().decode([Task].self, from: fileData)
        } catch {
            save()
        }
    }
}
