import SwiftUI

struct TaskListView: View {
    struct TaskSectionView<Subtitle: View>: View {
        @ObservedObject private var dataManager: DataManager
        private var sectionTitle: String
        private var sort: (Binding<Task>, Binding<Task>) -> Bool
        private var filter: (Binding<Task>) -> Bool
        @ViewBuilder private var displaySubtitle: (Task) -> Subtitle
        
        init(_ dataManager: DataManager, title: String, filter: @escaping (Binding<Task>) -> Bool, sortBy: @escaping (Binding<Task>, Binding<Task>) -> Bool, @ViewBuilder subtitle: @escaping (Task) -> Subtitle) {
            self.dataManager = dataManager
            self.sort = sortBy
            self.filter = filter
            self.sectionTitle = title
            self.displaySubtitle = subtitle
        }
        
        private var list: [Binding<Task>] {
            return $dataManager.data.filter(filter).sorted(by: sort)
        }
        
        var body: some View {
            if !list.isEmpty {
                Section(sectionTitle) {
                    ForEach(list, id: \.id) { task in
                        NavigationLink {
                            TaskDetailView(task, total: dataManager.totalSubtasks, finished: dataManager.finishedSubtasks)
                        } label: {
                            Label {
                                VStack(alignment: .leading) {
                                    Text(task.wrappedValue.name)
                                        .font(.headline)
                                        .lineLimit(1)
                                    displaySubtitle(task.wrappedValue)
                                }
                            } icon: {
                                ProgressView(value: CGFloat(task.wrappedValue.hasCompleted), total: CGFloat(task.wrappedValue.subtasks.count))
                                    .progressViewStyle(.circular)
                                    .padding(.all, 1)
                            }
                            .labelStyle(.listItem)
                        }
                        .contextMenu {
                            Button {
                                dataManager.data.removeAll { element in
                                    element.id == task.wrappedValue.id
                                }
                            } label: {
                                Text("删除")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ObservedObject private var dataManager: DataManager
    
    init(_ dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    var body: some View {
        List {
            TaskSectionView(dataManager, title: "已逾期") { task in
                return task.wrappedValue.overdue > 0
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text("逾期\(task.overdue)个子任务")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "今天") { task in
                return task.wrappedValue.date.isTheSameDay(as: Date.now) && task.wrappedValue.overdue == 0
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "未来7天") { task in
                return task.wrappedValue.date.isInTheNextDay(from: 1, to: 8)
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "未来30天") { task in
                return task.wrappedValue.date.isInTheNextDay(from: 8, to: 31)
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "未来半年") { task in
                return task.wrappedValue.date.isInTheNextDay(from: 31, to: 181)
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "未来") { task in
                return task.wrappedValue.date.isAfter(day: 181)
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
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
