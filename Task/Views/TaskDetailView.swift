import SwiftUI

struct TaskDetailView: View {
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
                            delete()
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
    
    @Binding private var task: Task
    private var totalSteps: Int
    private var finishedSteps: Int
    
    init(_ task: Binding<Task>, total: Int, finished: Int) {
        self._task = task
        self.totalSteps = total
        self.finishedSteps = finished
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                GroupBox {
                    VStack {
                        ForEach(0..<task.subtasks.count, id: \.self) { index in
                            SubtaskDetailView($task.subtasks[index], count: task.subtasks.count) {
                                task.subtasks.removeAll { other in
                                    task.subtasks[index].id == other.id
                                }
                            }
                            if index != task.subtasks.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(.all, 5)
                } label: {
                    TextEditor(text: $task.name)
                        .labelsHidden()
                        .textFieldStyle(.plain)
                        .font(.headline)
                }
            }
            .padding()
        }
        .background(Color(NSColor.controlBackgroundColor))
        .navigationTitle("待办事项")
        .navigationSubtitle("已完成 \(finishedSteps)/\(totalSteps) 个子任务")
        .toolbar {
            ToolbarItem {
                Spacer(minLength: 0)
            }
            ToolbarItem {
                Button {
                    task.subtasks.append(Subtask("子任务", "这是一个子任务。"))
                } label: {
                    Label("添加子任务", systemImage: "plus")
                }
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(.constant(Task("示例项目", subtasks: [Subtask("子任务", "这是一个子任务。")])), total: 10, finished: 5)
    }
}
