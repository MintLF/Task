import SwiftUI

struct SplitView: View {
    @ObservedObject private var dataManager: DataManager
    @State private var selection: UUID?
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    var body: some View {
        NavigationSplitView {
            TaskListView(dataManager, selection: $selection)
        } detail: {
            TaskDetailView($dataManager.data.first { $0.wrappedValue.id == selection }) {
                dataManager.data.removeAll { task in
                    task.id == selection
                }
            }
            .navigationTitle("待办事项")
            .navigationSubtitle("已完成 \(dataManager.finishedSubtasks)/\(dataManager.totalSubtasks) 个子任务")
        }
        .onDeleteCommand {
            dataManager.data.removeAll { element in
                element.id == selection
            }
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView(DataManager())
    }
}
