import SwiftUI

class TaskSettings: ObservableObject {
    @AppStorage("sidebarToolbarContent") var sidebarToolbarContent: [ToolbarContentItem] = [
        ToolbarContentItem("可变间距", image: "space"),
        ToolbarContentItem("添加任务", image: "plus")
    ]
    @AppStorage("detailToolbarContent") var detailToolbarContent: [ToolbarContentItem] = [
        ToolbarContentItem("窗口标题", image: "text.alignleft"),
        ToolbarContentItem("排序方式", image: "list.bullet"),
        ToolbarContentItem("添加子任务", image: "plus"),
        ToolbarContentItem("编辑", image: "square.and.pencil"),
        ToolbarContentItem("删除任务", image: "trash")
    ]
    @AppStorage("sidebarDisplayOverdue") var sidebarSubtitleDisplayOverdue: Bool = true
    @AppStorage("sidebarDisplayCountdown") var sidebarSubtitleDisplayCountdown: Bool = false
    @AppStorage("sidebarProgress") var sidebarProgress: SidebarProgress = .none
    @AppStorage("detailTitle") var detailTitle: DetailTitle = .appTitle
    @AppStorage("detailSubtitle") var detailSubtitle: DetailSubtitle = .allSubtasks
    @AppStorage("106updated") var updated: Bool = false
    static let shared = TaskSettings()
}

@propertyWrapper
struct Setting<T>: DynamicProperty {
    @ObservedObject private var settings: TaskSettings
    private let keyPath: ReferenceWritableKeyPath<TaskSettings, T>
    
    init(_ keyPath: ReferenceWritableKeyPath<TaskSettings, T>, settings: TaskSettings = .shared) {
        self.keyPath = keyPath
        self.settings = settings
    }

    var wrappedValue: T {
        get { settings[keyPath: keyPath] }
        nonmutating set { settings[keyPath: keyPath] = newValue }
    }

    var projectedValue: Binding<T> {
        Binding(
            get: { settings[keyPath: keyPath] },
            set: { value in
                settings[keyPath: keyPath] = value
            }
        )
    }
}

struct ToolbarContentItem: Codable, Identifiable {
    var id = UUID()
    
    var isShown: Bool = true
    var name: String
    var image: String
    
    init(_ name: String, image: String) {
        self.name = name
        self.image = image
    }
}

enum SidebarProgress: String {
    case residue = "residue"
    case completed = "completed"
    case all = "all"
    case none = "none"
}

enum DetailTitle: String {
    case appTitle = "appTitle"
    case taskTitle = "taskTitle"
}

enum DetailSubtitle: String {
    case allSubtasks = "allSubtasks"
    case subtasksInCurrentTask = "subtasksInCurrentTask"
    case latestSubtaskInCurrentTask = "latestSubtaskInCurrentTask"
}
