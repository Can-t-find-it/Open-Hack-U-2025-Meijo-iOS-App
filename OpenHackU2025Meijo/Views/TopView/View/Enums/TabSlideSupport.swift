import SwiftUI

enum TabSlideSupport {
    static func isForward(
        layoutDirection: LayoutDirection,
        from old: Int,
        to new: Int
    ) -> Bool {
        switch layoutDirection {
        case .leftToRight:
            // 右側のタブに進むとき（番号が大きくなる）を「前進」
            return new > old
        case .rightToLeft:
            // RTL は逆
            return new < old
        @unknown default:
            return new > old
        }
    }
}


