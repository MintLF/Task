import SwiftUI

struct ToolbarSettingsView: View {
    @Setting(\.sidebarToolbarContent) private var sidebarToolbarContent
    @Setting(\.detailToolbarContent) private var detailToolbarContent
    
    var body: some View {
        List {
            Section("侧边栏") {
                ForEach($sidebarToolbarContent, id: \.id) { item in
                    HStack {
                        Label(item.wrappedValue.name, systemImage: item.wrappedValue.image)
                        Spacer(minLength: 0)
                        Toggle(isOn: item.isShown) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(item.wrappedValue.isShown ? Color.accentColor : Color(UIColor.secondaryLabel))
                        }
                        .toggleStyle(.button)
                    }
                }
                .onMove { indices, newOffset in
                    sidebarToolbarContent.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            Section("主界面") {
                ForEach($detailToolbarContent, id: \.id) { item in
                    HStack {
                        Label(item.wrappedValue.name, systemImage: item.wrappedValue.image)
                        Spacer(minLength: 0)
                        Toggle(isOn: item.isShown) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(item.wrappedValue.isShown ? Color.accentColor : Color(UIColor.secondaryLabel))
                        }
                        .toggleStyle(.button)
                    }
                }
                .onMove { indices, newOffset in
                    detailToolbarContent.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
        }
        .navigationTitle("工具栏")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ToolbarSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ToolbarSettingsView()
        }
    }
}
