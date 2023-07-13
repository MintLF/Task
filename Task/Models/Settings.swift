import SwiftUI

class TaskSettings: ObservableObject {
    @AppStorage("sidebarToolbarContent") var sidebarToolbarContent: [ToolbarContentItem] = [ToolbarContentItem("可变间距", image: "space"), ToolbarContentItem("添加任务", image: "plus")]
    @AppStorage("detailToolbarContent") var detailToolbarContent: [ToolbarContentItem] = [ToolbarContentItem("可变间距", image: "space"), ToolbarContentItem("添加子任务", image: "plus"), ToolbarContentItem("删除任务", image: "trash")]
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
