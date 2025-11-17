import SwiftUI

struct SmoothSlidingHost<Content: View>: View {
    @Environment(\.layoutDirection) private var dir

    let selection: Tab
    var duration: Double = 0.28
    @ViewBuilder var content: (_ sel: Tab) -> Content

    @State private var leaving: Tab?
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
            .clipped()
            .onChange(of: selection) { old, new in
                leaving = old

                // ★ old/new から「前進方向かどうか」をここで決める
                let forward = TabSlideSupport.isForward(
                    layoutDirection: dir,
                    from: old.rawValue,
                    to: new.rawValue
                )
                print("host old: \(old), new: \(new), forward: \(forward)")

                inOffset  = forward ?  w : -w
                outOffset = 0

                withAnimation(.easeInOut(duration: duration)) {
                    inOffset  = 0
                    outOffset = forward ? -w :  w
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
