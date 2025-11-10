import SwiftUI
import AppColorTheme

struct TabBar: View {
    @Binding var selected: Tab
    var onSelect: (Tab) -> Void

    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { t in
                TabBarButton(tab: t, isSelected: selected == t) {
                    onSelect(t)
                }
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
//        .background(Color.white.opacity(0.25))
        .background(AppColorToken.background.surface)
        .shadow(color: .white.opacity(0.1), radius: 8, y: -2)
    }
}
