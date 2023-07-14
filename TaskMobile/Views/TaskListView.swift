import SwiftUI

struct TaskListView: View {
    @Setting(\.sidebarToolbarContent) private var sidebarToolbarContent
    @ObservedObject private var dataManager: DataManager
    @Binding private var selection: UUID?
    @State private var isOnSettingPage: Bool = false
    
    init(_ dataManager: DataManager, selection: Binding<UUID?>) {
        self.dataManager = dataManager
        self._selection = selection
    }
    
    var body: some View {
        List(selection: $selection) {
            TaskSectionView(dataManager, title: "已逾期") { task in
                return task.wrappedValue.overdue > 0 && !task.wrappedValue.isCompleted
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text("逾期\(task.overdue)个子任务")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "今天") { task in
                return task.wrappedValue.date.isTheSameDay(as: Date.now) && task.wrappedValue.overdue == 0 && !task.wrappedValue.isCompleted
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "未来7天") { task in
                return task.wrappedValue.date.isInTheNextDay(from: 1, to: 8) && !task.wrappedValue.isCompleted
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "未来30天") { task in
                return task.wrappedValue.date.isInTheNextDay(from: 8, to: 31) && !task.wrappedValue.isCompleted
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "未来半年") { task in
                return task.wrappedValue.date.isInTheNextDay(from: 31, to: 181) && !task.wrappedValue.isCompleted
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "未来") { task in
                return task.wrappedValue.date.isAfter(day: 181) && !task.wrappedValue.isCompleted
            } sortBy: { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            } subtitle: { task in
                Text(task.date.format(.all))
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            TaskSectionView(dataManager, title: "已完成") { task in
                return task.wrappedValue.isCompleted == true
            } sortBy: { first, second in
                return first.wrappedValue.name <= second.wrappedValue.name
            } subtitle: { task in
                Text("已完成")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .scrollContentBackground(.hidden)
        .onChange(of: selection) { [selection] newValue in
            if newValue == nil {
                self.selection = selection
            }
        }
        .toolbar {
            ToolbarItemGroup {
                ForEach(sidebarToolbarContent, id: \.id) { item in
                    if item.isShown {
                        if item.name == "可变间距" {
                            Spacer(minLength: 0)
                        } else if item.name == "添加任务" {
                            Button {
                                dataManager.data.append(Task("示例任务", subtasks: [Subtask("子任务", "这是一个子任务。")]))
                            } label: {
                                Label("添加任务", systemImage: "plus")
                            }
                        }
                    }
                }
                Button {
                    isOnSettingPage.toggle()
                } label: {
                    Label("设置", systemImage: "gear")
                }
            }
        }
        .sheet(isPresented: $isOnSettingPage) {
            SettingsView()
        }
    }
    
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
                        VStack(alignment: .leading) {
                            HStack {
                                Text(task.wrappedValue.name)
                                    .font(.headline)
                                    .lineLimit(1)
                                Spacer(minLength: 0)
                                displaySubtitle(task.wrappedValue)
                            }
                            ProgressView(value: CGFloat(task.wrappedValue.hasCompleted), total: CGFloat(task.wrappedValue.subtasks.count))
                                .progressViewStyle(.linear)
                                .padding(.all, 1)
                        }
                        .labelStyle(.listItem)
                        .tag(task.wrappedValue.id)
                    }
                    .onDelete { index in
                        for i in index {
                            dataManager.data.removeAll { task in
                                list[i].id == task.id
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TaskListView(DataManager(), selection: .constant(DataManager().data.first!.id))
        }
    }
}
