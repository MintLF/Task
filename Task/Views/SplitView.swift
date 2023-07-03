import SwiftUI

struct SplitView: View {
    @ObservedObject private var dataManager: DataManager
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    var body: some View {
        NavigationSplitView {
            TaskListView(dataManager)
        } detail: {
            WelcomeView()
                .navigationTitle("待办事项")
                .navigationSubtitle("已完成 \(dataManager.finishedSubtasks)/\(dataManager.totalSubtasks) 个子任务")
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView(DataManager())
    }
}
