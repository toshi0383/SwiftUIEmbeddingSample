import SwiftUI

struct ContentView: View {
    @State private var isCollapsed = false

    private var height: CGFloat { 150 }
    var color: Color
    var onChangeHeight: (CGFloat) -> ()

    init(color: Color = .blue, onChangeHeight: @escaping (CGFloat) -> Void) {
        self.color = color
        self.onChangeHeight = onChangeHeight
    }

    var body: some View {

        ZStack(alignment: .bottom) {

            GeometryReader { proxy in
                Group {
                    if proxy.size.width < 500 || isCollapsed {
                        VStack(spacing: 0) { content }
                    } else {
                        HStack(spacing: 0) { content }
                    }
                }
                .onSizeChange { onChangeHeight($0.height) }
            }
            Button("タップして高さ変更") {
                withAnimation {
                    isCollapsed.toggle()
                }
            }
            .padding(15)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(15)
        }
        .frame(maxWidth: .infinity)
    }

    private var content: some View {
        Group {
            Color.cyan
                .frame(height: height)
            Color.pink
                .frame(height: height)
        }
    }
}

// プレビュー
#Preview {
    ContentView { height in
        print(height)
    }
}
