import SwiftUI

struct ToolbarSettingsView: View {
    @Setting(\.sidebarToolbarContent) private var sidebarToolbarContent
    @Setting(\.detailToolbarContent) private var detailToolbarContent
    
    var body: some View {
        HStack(spacing: 0) {
            List {
                Section("侧边栏") {
                    ForEach($sidebarToolbarContent, id: \.id) { item in
                        HStack {
                            Label(item.wrappedValue.name, systemImage: item.wrappedValue.image)
                            Spacer(minLength: 0)
                            Toggle("", isOn: item.isShown)
                                .labelsHidden()
                        }
                    }
                    .onMove { indices, newOffset in
                        sidebarToolbarContent.move(fromOffsets: indices, toOffset: newOffset)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
            Divider()
            List {
                Section("主界面") {
                    ForEach($detailToolbarContent, id: \.id) { item in
                        HStack {
                            Label(item.wrappedValue.name, systemImage: item.wrappedValue.image)
                            Spacer(minLength: 0)
                            Toggle("", isOn: item.isShown)
                                .labelsHidden()
                        }
                    }
                    .onMove { indices, newOffset in
                        detailToolbarContent.move(fromOffsets: indices, toOffset: newOffset)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct ToolbarSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarSettingsView()
    }
}
