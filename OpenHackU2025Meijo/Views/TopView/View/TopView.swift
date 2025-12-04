import SwiftUI
import AppColorTheme

struct TopView: View {
    @Environment(\.layoutDirection) private var dir
    @State private var selectedTab: Tab = .home
    @State private var previous: Tab = .home
    @State private var isMenuOpen: Bool = false
    @State private var isTabBarHidden: Bool = false
    
    @State private var isForward: Bool = true
    
    @State var ShowSignInView: Bool = true // 本来はこっち
//    @State var ShowSignInView: Bool = false

    var body: some View {
        ZStack { // コンテンツ表示部分
            SmoothSlidingHost(selection: selectedTab, duration: 0.28) { sel in
                content(for: sel)
            }
        }
        .onPreferenceChange(TabBarHiddenKey.self) { hidden in
            isTabBarHidden = hidden
        }
        .overlay(alignment: .bottom) {
            TabBar(
                selected: $selectedTab,
                isMenuOpen: $isMenuOpen
            ) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        isMenuOpen = false
                    }
                }
            }
            .offset(y: isTabBarHidden ? 120 : 0)
            .opacity(isTabBarHidden ? 0 : 1)
        }
        .fullBackground()
        .fullScreenCover(isPresented: $ShowSignInView) {
            SignInView()
        }
    }

    // 画面本体
    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .home:    MyTextbookView()
        case .others:  FriendsLogView()
        case .add:     AddTextbookView()
        case .search:  SearchTextbookView()
        case .account: AccountView()
        }
    }
}

#Preview {
    TopView()
}
