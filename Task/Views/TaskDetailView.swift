import SwiftUI

struct TaskDetailView: View {
    @Setting(\.detailToolbarContent) private var detailToolbarContent
    private var task: Binding<Task>?
    private var delete: () -> Void
    
    init(_ task: Binding<Task>?, delete: @escaping () -> Void) {
        self.task = task
        self.delete = delete
    }
    
    private var sortedSubtasks: [Binding<Subtask>]? {
        return task?.subtasks.sorted { first, second in
            return first.wrappedValue.date <= second.wrappedValue.date
        }
    }
    
    var body: some View {
        Group {
            if task == nil {
                WelcomeView()
            } else {
                List {
                    ForEach(0..<sortedSubtasks!.count, id: \.self) { index in
                        SubtaskDetailView(sortedSubtasks![index], count: sortedSubtasks!.count) {
                            task!.wrappedValue.subtasks.removeAll { other in
                                sortedSubtasks![index].id == other.id
                            }
                        }
                    }
                }
                .listStyle(InsetListStyle(alternatesRowBackgrounds: true))
            }
        }
        .toolbar {
            ToolbarItemGroup {
                ForEach(detailToolbarContent, id: \.id) { item in
                    if item.isShown {
                        if item.name == "可变间距" {
                            Spacer(minLength: 0)
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
        @State private var isEditingDate: Bool = false
        @Binding private var subtask: Subtask
        private var count: Int
        private var delete: () -> Void
        
        init(_ subtask: Binding<Subtask>, count: Int, delete: @escaping () -> Void) {
            self._subtask = subtask
            self.count = count
            self.delete = delete
        }
        
        var body: some View {
            HStack {
                Toggle("", isOn: $subtask.isCompleted)
                    .labelsHidden()
                VStack(spacing: 0) {
                    HStack {
                        TextField("", text: $subtask.name)
                            .labelsHidden()
                            .textFieldStyle(.plain)
                            .font(.headline)
                        Spacer(minLength: 0)
                        Button {
                            isEditingDate.toggle()
                        } label: {
                            Text(subtask.date.format(.all))
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .popover(isPresented: $isEditingDate) {
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
                        .buttonStyle(.plain)
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
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(.constant(Task("示例项目", subtasks: [Subtask("子任务", "这是一个子任务。", isCompleted: true), Subtask("子任务", "这是一个子任务。", date: Date.distantFuture), Subtask("子任务", "这是一个子任务。", date: Date.distantPast)]))) {}
    }
}
