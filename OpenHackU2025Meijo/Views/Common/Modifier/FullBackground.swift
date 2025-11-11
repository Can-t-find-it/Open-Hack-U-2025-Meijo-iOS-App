import SwiftUI
import AppColorTheme

extension View {
    func fullBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColorToken.background.surface)
    }
}
