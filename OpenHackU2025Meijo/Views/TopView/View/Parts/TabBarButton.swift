import SwiftUI
import AppColorTheme

struct TabBarButton: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? tab.filledSystemImage : tab.systemImage)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .foregroundColor(foregroundColor)
                .accessibilityLabel(tab.accessibilityLabel)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }

    // 色分け処理
    private var foregroundColor: Color {
        if tab == .add {
            // Addボタンは常に赤
            return AppColorToken.background.surface
        } else {
            // その他は常に白
            return .white
        }
    }
}

#Preview {
    TopView()
}
