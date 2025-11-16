import SwiftUI
import AppColorTheme

struct TopView: View {
    @Environment(\.layoutDirection) private var dir
    @State private var selectedTab: Tab = .home
    @State private var previous: Tab = .home
    @State private var isMenuOpen: Bool = false
    @State private var isTabBarHidden: Bool = false

    var body: some View {
        ZStack { // コンテンツ表示部分
            SmoothSlidingHost(selection: selectedTab, isForward: isForward, duration: 0.28) { sel in
                content(for: sel)
            }
        }
        .overlay(alignment: .bottom) { // タブバー表示部分
            if !isTabBarHidden {
                TabBar(
                    selected: $selectedTab,
                    isMenuOpen: $isMenuOpen
                ) { t in
                    previous = selectedTab
                    selectedTab = t

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            isMenuOpen = false
                        }
                    }
                }
            }
        }
        .fullBackground()
    }

    // 画面本体
    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .home:    MyTextbookView(isTabBarHidden: $isTabBarHidden)
        case .others:  OthersTextbookView()
        case .add:     AddTextbookView()
        case .search:  SearchTextbookView()
        case .account: AccountView()
        }
    }

    // 遷移アニメーションの向き
    private var isForward: Bool {
        TabSlideSupport.isForward(
            layoutDirection: dir,
            selected: selectedTab.rawValue,
            previous: previous.rawValue
        )
    }
}

#Preview {
    TopView()
}
