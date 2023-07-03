import SwiftUI

struct TaskDetailView: View {
    struct SubtaskDetailView: View {
        @State private var isEditingDate: Bool = false
        @Binding private var subtask: Subtask
        private var index: Int
        
        init(_ subtask: Binding<Subtask>, index: Int) {
            self._subtask = subtask
            self.index = index
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
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        .popover(isPresented: $isEditingDate) { 
                            CalendarWidget($subtask.date)
                                .padding()
                        }
                        
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
    private var isDeleted: Bool
    private var totalSteps: Int
    private var finishedSteps: Int
    
    init(_ task: Binding<Task>, total: Int, finished: Int, isDeleted: Bool) {
        self._task = task
        self.totalSteps = total
        self.finishedSteps = finished
        self.isDeleted = isDeleted
    }
    
    var body: some View {
        if isDeleted {
            WelcomeView()
                .navigationTitle("待办事项")
                .navigationSubtitle("已完成 \(finishedSteps)/\(totalSteps) 个子任务")
        } else {
            ScrollView(.vertical) {
                VStack {
                    GroupBox {
                        VStack {
                            ForEach(0..<task.subtasks.count, id: \.self) { index in
                                SubtaskDetailView($task.subtasks[index], index: index)
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
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(.constant(Task("示例项目", subtasks: [Subtask("子任务", "这是一个子任务。")])), total: 10, finished: 5, isDeleted: false)
    }
}
