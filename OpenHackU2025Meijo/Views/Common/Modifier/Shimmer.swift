import SwiftUI

extension View {
    func shimmer() -> some View {
        self
            .overlay(
                ShimmerOverlay()
            )
            .mask(self)
    }
}

struct ShimmerOverlay: View {
    @State private var move = false

    var body: some View {
        LinearGradient(
            colors: [
                .clear,
                Color.white.opacity(0.6),
                .clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .offset(x: move ? 300 : -300)
        .animation(
            .linear(duration: 1.2).repeatForever(autoreverses: false),
            value: move
        )
        .onAppear {
            move = true
        }
    }
}
