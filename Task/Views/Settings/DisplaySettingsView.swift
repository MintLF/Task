import SwiftUI

struct DisplaySettingsView: View {
    @Setting(\.sidebarSubtitleDisplayOverdue) private var sidebarSubtitleDisplayOverdue
    @Setting(\.sidebarSubtitleDisplayCountdown) private var sidebarSubtitleDisplayCountdown
    @Setting(\.sidebarProgress) private var sidebarProgress
    @Setting(\.detailTitle) private var detailTitle
    @Setting(\.detailSubtitle) private var detailSubtitle
    @State private var sidebarItem: SidebarSettingItems = .progress
    @State private var windowTitleItem: WindowTitleSettingItems = .title
    
    var body: some View {
        List {
            Section("侧边栏") {
                HStack {
                    Label {
                        VStack(alignment: .leading) {
                            Button {
                                withAnimation(.linear(duration: 0.1)) {
                                    sidebarItem = .title
                                }
                            } label: {
                                Text("任务标题")
                                    .font(.headline)
                                    .lineLimit(1)
                            }
                            .buttonStyle(.plain)
                            .overlay {
                                Rectangle()
                                    .stroke(sidebarItem == .title ? Color.accentColor : Color.clear, style: StrokeStyle())
                                    .padding(.all, -0.5)
                            }
                            Button {
                                withAnimation(.linear(duration: 0.1)) {
                                    sidebarItem = .subtitle
                                }
                            } label: {
                                Text(Date(year: 2030, month: 1, day: 1).format(.all))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            .buttonStyle(.plain)
                            .overlay {
                                Rectangle()
                                    .stroke(sidebarItem == .subtitle ? Color.accentColor : Color.clear, style: StrokeStyle())
                                    .padding(.all, -0.5)
                            }
                        }
                    } icon: {
                        Button {
                            withAnimation(.linear(duration: 0.1)) {
                                sidebarItem = .progress
                            }
                        } label: {
                            ZStack(alignment: .center) {
                                switch sidebarProgress {
                                case .residue:
                                    Text("3")
                                        .foregroundStyle(.secondary)
                                case .completed:
                                    Text("2")
                                        .foregroundStyle(.secondary)
                                case .all:
                                    Text("3/5")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                case .none:
                                    EmptyView()
                                }
                                ProgressView(value: CGFloat(2), total: CGFloat(5))
                                    .progressViewStyle(.circular)
                                    .padding(.all, 1)
                            }
                        }
                        .buttonStyle(.plain)
                        .overlay {
                            Rectangle()
                                .stroke(sidebarItem == .progress ? Color.accentColor : Color.clear, style: StrokeStyle())
                                .padding(.all, -2)
                        }
                    }
                    .labelStyle(.listItem)
                    Divider()
                        .padding(.leading)
                        .padding(.trailing)
                    Group {
                        switch sidebarItem {
                        case .progress:
                            VStack(alignment: .leading) {
                                Text("在进度条中央显示：")
                                Divider()
                                Picker("", selection: $sidebarProgress) {
                                    Text("不显示")
                                        .tag(SidebarProgress.none)
                                    Text("未完成的子任务个数")
                                        .tag(SidebarProgress.residue)
                                    Text("已完成的子任务个数")
                                        .tag(SidebarProgress.completed)
                                    Text("全部显示")
                                        .tag(SidebarProgress.all)
                                }
                                .pickerStyle(InlinePickerStyle())
                                .labelsHidden()
                                .padding(.leading)
                            }
                            
                        case .title:
                            Text("暂无自定义内容")
                                .foregroundStyle(.secondary)
                        case .subtitle:
                            VStack(alignment: .leading) {
                                Toggle("在有子任务逾期时显示逾期的子任务个数", isOn: $sidebarSubtitleDisplayOverdue)
                                Divider()
                                Toggle("在有子任务完成时间在24小时内时显示剩余时间", isOn: $sidebarSubtitleDisplayCountdown)
                            }
                        }
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
            .listRowSeparator(.hidden)
            Section("窗口标题") {
                HStack {
                    VStack(alignment: .leading) {
                        Button {
                            withAnimation(.linear(duration: 0.1)) {
                                windowTitleItem = .title
                            }
                        } label: {
                            Group {
                                switch detailTitle {
                                case .appTitle:
                                    Text("待办事项")
                                case .taskTitle:
                                    Text("任务标题")
                                }
                            }
                            .font(.headline)
                        }
                        .buttonStyle(.plain)
                        .overlay {
                            Rectangle()
                                .stroke(windowTitleItem == .title ? Color.accentColor : Color.clear, style: StrokeStyle())
                                .padding(.all, -0.5)
                        }
                        Button {
                            withAnimation(.linear(duration: 0.1)) {
                                windowTitleItem = .subtitle
                            }
                        } label: {
                            Group {
                                switch detailSubtitle {
                                case .allSubtasks:
                                    Text("已完成 20/43 个子任务")
                                case .subtasksInCurrentTask:
                                    Text("已完成 3/5 个子任务")
                                case .latestSubtaskInCurrentTask:
                                    Text(Date(year: 2030, month: 1, day: 1).format(.all))
                                }
                            }
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .overlay {
                            Rectangle()
                                .stroke(windowTitleItem == .subtitle ? Color.accentColor : Color.clear, style: StrokeStyle())
                                .padding(.all, -0.5)
                        }
                    }
                    Divider()
                        .padding(.leading)
                        .padding(.trailing)
                    switch windowTitleItem {
                    case .title:
                        VStack(alignment: .leading) {
                            Text("在窗口标题栏显示：")
                            Divider()
                            Picker("", selection: $detailTitle) {
                                Text("待办事项")
                                    .tag(DetailTitle.appTitle)
                                Text("当前任务名称")
                                    .tag(DetailTitle.taskTitle)
                            }
                            .pickerStyle(InlinePickerStyle())
                            .labelsHidden()
                            .padding(.leading)
                        }
                    case .subtitle:
                        VStack(alignment: .leading) {
                            Text("在窗口副标题栏显示：")
                            Divider()
                            Picker("", selection: $detailSubtitle) {
                                Text("所有子任务的完成进度")
                                    .tag(DetailSubtitle.allSubtasks)
                                Text("当前任务中子任务的完成进度")
                                    .tag(DetailSubtitle.subtasksInCurrentTask)
                                Text("最近子任务的完成时间")
                                    .tag(DetailSubtitle.latestSubtaskInCurrentTask)
                            }
                            .pickerStyle(InlinePickerStyle())
                            .labelsHidden()
                            .padding(.leading)
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                .listRowSeparator(.hidden)
            }
        }
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
    }
    
    enum SidebarSettingItems {
        case progress
        case title
        case subtitle
    }
    
    enum WindowTitleSettingItems {
        case title
        case subtitle
    }
}

struct DisplaySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySettingsView()
    }
}
