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
        }
    }
}

struct SplitView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView(DataManager())
    }
}
