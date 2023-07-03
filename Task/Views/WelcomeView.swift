import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("欢迎使用Task！")
                .font(.system(size: 40, weight: .ultraLight))
            Text("在左侧选取项目以快速开始")
                .padding()
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
