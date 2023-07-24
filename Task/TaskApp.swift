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
                        detailToolbarContent.removeAll {
                            $0.name == "可变间距"
                        }
                        detailToolbarContent.insert(ToolbarContentItem("排序方式", image: "list.bullet"), at: 0)
                        updated = true
                    }
                }
        }
        Settings {
            SettingsView()
        }
    }
}
