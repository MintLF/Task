import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ToolbarSettingsView()
                } label: {
                    Label("工具栏", systemImage: "menubar.rectangle")
                }
            }
            .navigationTitle("设置")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
