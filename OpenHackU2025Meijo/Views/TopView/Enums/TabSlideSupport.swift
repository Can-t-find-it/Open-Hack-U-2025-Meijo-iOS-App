import SwiftUI

enum TabSlideSupport {
    /// 進む方向かどうかを判定（LTR/RTL対応）
    static func isForward(
        layoutDirection: LayoutDirection,
        selected: Int,
        previous: Int
    ) -> Bool {
        switch layoutDirection {
        case .leftToRight:
            // 右→左に「進む」なら（一般的）: 新 > 旧
            return selected > previous
            // もし逆向きにしたいなら、上を `selected < previous` に変えてください
        case .rightToLeft:
            return selected < previous
        @unknown default:
            return selected > previous
        }
    }
}
