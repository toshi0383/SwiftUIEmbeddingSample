import SwiftUI

// サイズを伝達するためのPreferenceKeyの定義
public struct OnSizeChangeModifierSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// サイズ変更を通知するModifier
public struct OnSizeChangeModifier: ViewModifier {
    let action: (CGSize) -> Void

    public init(action: @escaping (CGSize) -> Void) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                Color.clear
                    .frame(maxHeight: .infinity)
                    .preference(key: OnSizeChangeModifierSizePreferenceKey.self, value: proxy.size)
                    .onAppear(perform: { action(proxy.size) })
            })
            .onPreferenceChange(OnSizeChangeModifierSizePreferenceKey.self, perform: action)
    }
}

// View ExtensionでonSizeChangeを簡単に使用できるようにする
extension View {
    public func onSizeChange(perform action: @escaping (CGSize) -> Void) -> some View {
        self.modifier(OnSizeChangeModifier(action: action))
    }
}
