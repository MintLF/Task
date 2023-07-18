import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            DisplaySettingsView()
                .tabItem {
                    Label("显示", systemImage: "macwindow.on.rectangle")
                }
            ToolbarSettingsView()
                .tabItem {
                    Label("工具栏", systemImage: "menubar.rectangle")
                }
        }
        .frame(minWidth: 400, minHeight: 200)
        .onAppear {
            NSApplication.shared.windows.first { $0.title == "显示" || $0.title == "工具栏"  }? .backgroundColor = .clear
        }
        .background(.ultraThickMaterial)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
