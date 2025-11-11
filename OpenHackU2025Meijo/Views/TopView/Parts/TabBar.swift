import SwiftUI
import AppColorTheme

struct TabBar: View {
    @Binding var selected: Tab
    var onSelect: (Tab) -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(Tab.allCases, id: \.self) { t in
                    TabBarButton(tab: t, isSelected: selected == t) {
                        onSelect(t)
                    }
                }
            }
            .custom3DBackground(width: 380, height: 60, cornerRadius: 50)
        }
        .padding(.bottom, 30)
        .ignoresSafeArea()
    }
}

#Preview {
    TopView()
}
