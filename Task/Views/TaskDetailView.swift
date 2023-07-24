import SwiftUI

struct TaskDetailView: View {
    @Setting(\.detailToolbarContent) private var detailToolbarContent
    @State private var currentEditingDate: UUID? = nil
    @State private var sortedType: SortMode = .overdue
    private var task: Binding<Task>?
    private var delete: () -> Void
    
    init(_ task: Binding<Task>?, delete: @escaping () -> Void) {
        self.task = task
        self.delete = delete
    }
    
    private var sortedSubtasks: [Binding<Subtask>]? {
        if sortedType == .overdue {
            return task?.subtasks.sorted { first, second in
                return first.wrappedValue.date <= second.wrappedValue.date
            }
        } else if sortedType == .name {
            return task?.subtasks.sorted { first, second in
                return first.wrappedValue.name <= second.wrappedValue.name
            }
        } else {
            return nil
        }
    }
    
    var body: some View {
        Group {
            if let task = task {
                List {
                    switch sortedType {
                    case .default:
                        ForEach(task.subtasks, id: \.id) { subtask in
                            SubtaskDetailView(subtask, count: task.wrappedValue.count, currentEditingDate: $currentEditingDate) {
                                task.wrappedValue.subtasks.removeAll { other in
                                    subtask.id == other.id
                                }
                            }
                        }
                        .onMove { from, to in
                            task.wrappedValue.subtasks.move(fromOffsets: from, toOffset: to)
                        }
                    case .overdue:
                        Group {
                            let overdue = sortedSubtasks!.filter { $0.wrappedValue.isOverdue }
                            let todo = sortedSubtasks!.filter { !$0.wrappedValue.isOverdue && !$0.wrappedValue.isCompleted }
                            let hasCompleted = sortedSubtasks!.filter { $0.wrappedValue.isCompleted }
                            if !overdue.isEmpty {
                                Section("已逾期") {
                                    ForEach(0..<overdue.count, id: \.self) { index in
                                        SubtaskDetailView(overdue[index], count: overdue.count, currentEditingDate: $currentEditingDate) {
                                            task.wrappedValue.subtasks.removeAll { other in
                                                overdue[index].id == other.id
                                            }
                                        }
                                    }
                                }
                            }
                            if !todo.isEmpty {
                                Section("未完成") {
                                    ForEach(0..<todo.count, id: \.self) { index in
                                        SubtaskDetailView(todo[index], count: todo.count, currentEditingDate: $currentEditingDate) {
                                            task.wrappedValue.subtasks.removeAll { other in
                                                todo[index].id == other.id
                                            }
                                        }
                                    }
                                }
                            }
                            if !hasCompleted.isEmpty {
                                Section("已完成") {
                                    ForEach(0..<hasCompleted.count, id: \.self) { index in
                                        SubtaskDetailView(hasCompleted[index], count: hasCompleted.count, currentEditingDate: $currentEditingDate) {
                                            task.wrappedValue.subtasks.removeAll { other in
                                                hasCompleted[index].id == other.id
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    case .name:
                        ForEach(0..<sortedSubtasks!.count, id: \.self) { index in
                            SubtaskDetailView(sortedSubtasks![index], count: sortedSubtasks!.count, currentEditingDate: $currentEditingDate) {
                                task.wrappedValue.subtasks.removeAll { other in
                                    sortedSubtasks![index].id == other.id
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetListStyle(alternatesRowBackgrounds: true))
            } else {
                WelcomeView()
            }
        }
        .toolbar {
            ToolbarItemGroup {
                ForEach(detailToolbarContent, id: \.id) { item in
                    if item.isShown {
                        if item.name == "排序方式" {
                            Picker("", selection: $sortedType) {
                                HStack {
                                    Image(systemName: "list.bullet")
                                    Text("默认排序")
                                }
                                .tag(SortMode.default)
                                HStack {
                                    Image(systemName: "list.bullet.indent")
                                    Text("按完成情况排序")
                                }
                                .tag(SortMode.overdue)
                                HStack {
                                    Image(systemName: "list.number")
                                    Text("按名称排序")
                                }
                                .tag(SortMode.name)
                            }
                        } else if item.name == "添加子任务" {
                            Button {
                                task!.wrappedValue.subtasks.append(Subtask("子任务", "这是一个子任务。"))
                            } label: {
                                Label("添加子任务", systemImage: "plus")
                            }
                            .disabled(task == nil)
                        } else if item.name == "删除任务" {
                            Button {
                                delete()
                            } label: {
                                Label("删除任务", systemImage: "trash")
                            }
                            .disabled(task == nil)
                        }
                    }
                }
            }
        }
    }
    
    struct SubtaskDetailView: View {
        @Binding private var subtask: Subtask
        @Binding private var currentEditingDate: UUID?
        private var count: Int
        private var delete: () -> Void
        
        init(_ subtask: Binding<Subtask>, count: Int, currentEditingDate: Binding<UUID?>, delete: @escaping () -> Void) {
            self._subtask = subtask
            self.count = count
            self.delete = delete
            self._currentEditingDate = currentEditingDate
        }
        
        private var isEditingDate: Binding<Bool> {
            Binding<Bool> {
                currentEditingDate == subtask.id
            } set: { value in
                if value {
                    currentEditingDate = subtask.id
                } else {
                    currentEditingDate = nil
                }
            }

        }
        
        var body: some View {
            HStack {
                Toggle("", isOn: $subtask.isCompleted)
                    .labelsHidden()
                VStack(spacing: 0) {
                    HStack {
                        ZStack {
                            TextField("", text: $subtask.name)
                                .labelsHidden()
                                .textFieldStyle(.plain)
                                .font(.headline)
                        }
                        Spacer(minLength: 0)
                        Button {
                            currentEditingDate = subtask.id
                        } label: {
                            Text(subtask.date.format(.all))
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.default)
                        .popover(isPresented: isEditingDate) {
                            CalendarWidget($subtask.date)
                                .padding()
                        }
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                delete()
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.default)
                        .disabled(count == 1)
                    }
                    TextEditor(text: $subtask.description)
                        .scrollDisabled(true)
                        .scrollContentBackground(.hidden)
                        .textFieldStyle(.plain)
                        .font(.body)
                        .padding(.leading, -5)
                }
            }
            .padding(.all, 5)
        }
    }
    
    enum SortMode {
        case `default`
        case overdue
        case name
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(.constant(Task("示例项目", subtasks: [Subtask("子任务", "这是一个子任务。", isCompleted: true), Subtask("子任务", "这是一个子任务。", date: Date.distantFuture), Subtask("子任务", "这是一个子任务。", date: Date.distantPast)]))) {}
    }
}
