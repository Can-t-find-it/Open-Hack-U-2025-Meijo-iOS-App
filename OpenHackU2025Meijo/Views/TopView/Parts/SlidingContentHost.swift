import SwiftUI
import AppColorTheme

struct SlidingContentHost<Selection: Hashable, Content: View>: View {
    let selection: Selection               // 現在の選択（.id に使う）
    let isForward: Bool                    // 進む/戻るの向き
    var animation: Animation = .easeInOut(duration: 0.5)
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            ZStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColorToken.background.surface)
            
            content()
                .transition(.horizontalSlide(forward: isForward))
                .id(selection)
        }
        .animation(animation, value: selection)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
