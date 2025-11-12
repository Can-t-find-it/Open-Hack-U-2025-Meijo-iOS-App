import SwiftUI

extension AnyTransition {
    /// 前進: 新しい画面が右→左へ、戻る: 左→右へ
    static func horizontalSlide(forward: Bool) -> AnyTransition {
        let insertion = AnyTransition.move(edge: forward ? .trailing : .leading)
        let removal   = AnyTransition.move(edge: forward ? .leading  : .trailing)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
