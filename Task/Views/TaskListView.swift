import SwiftUI

struct TaskListView: View {
    @ObservedObject private var dataManager: DataManager
    @State private var selection: UUID?
    @State private var isDeleted: Bool = false
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(0..<dataManager.data.count, id: \.self) { index in
                NavigationLink {
                    TaskDetailView($dataManager.data[index], total: dataManager.totalSubtasks, finished: dataManager.finishedSubtasks, isDeleted: isDeleted)
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text(dataManager.data[index].name)
                                .font(.headline)
                                .lineLimit(1)
                            Text(dataManager.data[index].date.format(.all))
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    } icon: {
                        ProgressView(value: CGFloat(dataManager.data[index].hasCompleted), total: CGFloat(dataManager.data[index].subtasks.count))
                            .progressViewStyle(.circular)
                            .padding(.all, 1)
                    }
                    .labelStyle(.listItem)
                }
                .contextMenu {
                    Button {
                        if dataManager.data[index].id == selection {
                            isDeleted = true
                        }
                        dataManager.data.removeAll { element in
                            element.id == dataManager.data[index].id
                        }
                    } label: {
                        Text("删除")
                    }
                }
            }
            .onMove { from, toIndex in
                dataManager.data.move(fromOffsets: from, toOffset: toIndex)
            }
            .onChange(of: selection) { _ in
                isDeleted = false
            }
        }
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem {
                Spacer(minLength: 0)
            }
            ToolbarItem {
                Button {
                    dataManager.data.append(Task("示例任务", subtasks: [Subtask("子任务", "这是一个子任务。")]))
                } label: {
                    Label("添加任务", systemImage: "plus")
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitView {
            TaskListView(DataManager())
        } detail: {}
    }
}
