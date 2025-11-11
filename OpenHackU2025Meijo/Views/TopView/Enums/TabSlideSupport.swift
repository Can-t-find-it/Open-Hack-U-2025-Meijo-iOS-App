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
            return selected > previous
        case .rightToLeft:
            return selected < previous
        @unknown default:
            return selected > previous
        }
    }
}
