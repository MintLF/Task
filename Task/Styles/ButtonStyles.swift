import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    @State private var isOnHovering = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .fill(isOnHovering ? Color(NSColor.textColor).opacity(0.1) : Color.clear)
                    .onHover { status in
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isOnHovering = status
                        }
                    }
                    .padding(.vertical, -1.5)
                    .padding(.horizontal, -4)
            }
    }
}

struct DateButtonStyle: ButtonStyle {
    @State private var isOnHovering = false
    private var isChosen: Bool
    
    init(_ isChosen: Bool) {
        self.isChosen = isChosen
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Circle()
                .fill(isChosen ? .accentColor : Color(NSColor.textColor).opacity(isOnHovering ? 0.2 : 0.05))
                .frame(width: 30, height: 30)
            configuration.label
                .font(.title3.weight(.ultraLight))
                .foregroundColor(isChosen ? .white : .primary)
        }
        .onHover { status in
            withAnimation(.easeInOut(duration: 0.15)) {
                isOnHovering = status
            }
        }
    }
}

extension ButtonStyle where Self == DefaultButtonStyle {
    static var `default`: DefaultButtonStyle {
        DefaultButtonStyle()
    }
}

extension ButtonStyle where Self == DateButtonStyle {
    static func date(isChosen: Bool) -> DateButtonStyle {
        DateButtonStyle(isChosen)
    }
}
