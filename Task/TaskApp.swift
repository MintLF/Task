import SwiftUI

@main
struct TaskApp: App {
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
        }
        Settings {
            SettingsView()
        }
    }
}
