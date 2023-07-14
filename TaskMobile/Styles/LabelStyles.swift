import SwiftUI

struct ListItemLabelStyle: LabelStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}

extension LabelStyle where Self == ListItemLabelStyle {
    static var listItem: ListItemLabelStyle {
        ListItemLabelStyle()
    }
}
