import SwiftUI

@main
struct TaskApp: App {
    @Setting(\.updated) private var updated: Bool
    @Setting(\.detailToolbarContent) private var detailToolbarContent
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            SplitView(dataManager)
                .task {
                    dataManager.load()
                }
                .onChange(of: dataManager.data) { _ in
                    dataManager.save()
                }
                .onAppear {
                    if !updated {
                        detailToolbarContent = [
                            ToolbarContentItem("窗口标题", image: "text.alignleft"),
                            ToolbarContentItem("排序方式", image: "list.bullet"),
                            ToolbarContentItem("添加子任务", image: "plus"),
                            ToolbarContentItem("编辑", image: "square.and.pencil"),
                            ToolbarContentItem("删除任务", image: "trash")
                        ]
                        updated = true
                    }
                }
        }
        Settings {
            SettingsView()
        }
    }
}
