import SwiftUI

struct SmoothSlidingHost<Selection: Hashable, Content: View>: View {
    let selection: Selection
    let isForward: Bool
    var duration: Double = 0.28
    @ViewBuilder var content: (_ sel: Selection) -> Content

    @State private var leaving: Selection?
    @State private var inOffset: CGFloat = 0
    @State private var outOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack(alignment: .center) {
                // 出ていく側
                if let leaving {
                    content(leaving)
                        // ここで必ずコンテンツを“画面サイズ”に拡張・中央寄せ
                        .frame(width: w, height: h, alignment: .center)
                        .offset(x: outOffset)
                        .transition(.identity)
                        .zIndex(0)
                }

                // 入ってくる側
                content(selection)
                    .frame(width: w, height: h, alignment: .center)
                    .offset(x: inOffset)
                    .transition(.identity)
                    .zIndex(1)
            }
            .clipped() // はみ出しを切り落としてチラつき防止
            .onChange(of: selection) { old, new in
                leaving = old
                inOffset  = isForward ?  w : -w
                outOffset = 0

                withAnimation(.easeInOut(duration: duration)) {
                    inOffset  = 0
                    outOffset = isForward ? -w :  w
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    leaving = nil
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}
