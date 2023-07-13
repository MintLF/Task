import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            ToolbarSettingsView()
                .tabItem {
                    Label("工具栏", systemImage: "menubar.rectangle")
                }
        }
        .frame(minWidth: 400, minHeight: 200)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
