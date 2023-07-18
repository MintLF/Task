import SwiftUI

struct SplitView: View {
    @Setting(\.detailTitle) private var detailTitle
    @Setting(\.detailSubtitle) private var detailSubtitle
    @ObservedObject private var dataManager: DataManager
    @State private var selection: UUID?
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    private var title: String {
        switch detailTitle {
        case .appTitle:
            return "待办事项"
        case .taskTitle:
            if let selection = selection {
                return "\(dataManager.data.first { $0.id == selection }!.name)"
            } else {
                return "未选中项目"
            }
        }
    }
    
    private var subtitle: String {
        switch detailSubtitle {
        case .allSubtasks:
            return "已完成 \(dataManager.finishedSubtasks)/\(dataManager.totalSubtasks) 个子任务"
        case .subtasksInCurrentTask:
            if let selection = selection {
                let task = dataManager.data.first { $0.id == selection }!
                return "已完成 \(task.hasCompleted)/\(task.count) 个子任务"
            } else {
                return "欢迎使用Task"
            }
        case .latestSubtaskInCurrentTask:
            if let selection = selection {
                return dataManager.data.first { $0.id == selection }!.date.format(.all)
            } else {
                return "欢迎使用Task"
            }
        }
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
            .navigationTitle(title)
            .navigationSubtitle(subtitle)
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
