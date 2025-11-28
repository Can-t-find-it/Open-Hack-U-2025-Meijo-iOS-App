import SwiftUI

// タブバーを隠すかどうかを子ビューから親に伝えるためのキー
struct TabBarHiddenKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        // 「どこか1つでも true を出したら隠す」というルール
        value = value || nextValue()
    }
}

extension View {
    /// この画面でタブバーを隠す/表示する指定
    func tabBarHidden(_ hidden: Bool) -> some View {
        preference(key: TabBarHiddenKey.self, value: hidden)
    }
}
