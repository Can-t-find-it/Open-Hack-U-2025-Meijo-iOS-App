import SwiftUI
import AppColorTheme

struct TabBar: View {
    @Binding var selected: Tab
    @Binding var isMenuOpen: Bool
    var onSelect: (Tab) -> Void

    private let collapsedWidth: CGFloat = 50
    private let expandedWidth: CGFloat = 370
    private let height: CGFloat = 50
    private let cornerRadius: CGFloat = 50

    var body: some View {
        VStack {
            Spacer()

            StretchyMenuRow(
                tabs: Tab.allCases,
                selected: $selected,
                isMenuOpen: $isMenuOpen,
                onSelect: onSelect,
                collapsedWidth: collapsedWidth,
                expandedWidth: expandedWidth,
                height: height,
                cornerRadius: cornerRadius
            )
        }
        .padding(.bottom, 30)
        .ignoresSafeArea()
    }
}

private struct StretchyMenuRow: View {
    let tabs: [Tab]
    @Binding var selected: Tab
    @Binding var isMenuOpen: Bool
    var onSelect: (Tab) -> Void

    let collapsedWidth: CGFloat
    let expandedWidth: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat

    var body: some View {
        HStack {
            Spacer()

            ZStack {
                HStack {
                    ForEach(tabs, id: \.self) { t in
                        TabBarButton(tab: t, isSelected: selected == t) {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                selected = t
                                onSelect(t)
                            }
                        }
                    }
                }
                .opacity(isMenuOpen ? 1 : 0)

                // 閉じているときの丸アイコン
                Image(systemName: "list.bullet")                    .foregroundStyle(.white)
                    .font(.system(size: 28, weight: .medium))
                    .opacity(isMenuOpen ? 0 : 1)
            }
            .frame(
                width: isMenuOpen ? expandedWidth : collapsedWidth,
                height: height
            )
            .custom3DBackground(
                width: isMenuOpen ? expandedWidth : collapsedWidth,
                height: height,
                cornerRadius: cornerRadius
            )
            .contentShape(Rectangle())
            .onTapGesture {
                guard !isMenuOpen else { return }

                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isMenuOpen = true
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TopView()
}
