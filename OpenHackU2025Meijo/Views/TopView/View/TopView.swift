import SwiftUI
import AppColorTheme

struct TopView: View {
    @Environment(\.layoutDirection) private var dir
    @State private var selectedTab: Tab = .home
    @State private var previous: Tab = .home

    var body: some View {
        ZStack { // コンテンツ表示部分
//            SlidingContentHost(
//                selection: selectedTab,
//                isForward: isForward,
//                animation: .easeInOut(duration: 0.5)
//            ) {
//                content(for: selectedTab)
//            }
            SmoothSlidingHost(selection: selectedTab, isForward: isForward, duration: 0.28) { sel in
                content(for: sel)
            }
        }
        .overlay(alignment: .bottom) { // タブバー表示部分
            TabBar(selected: $selectedTab) { t in
                previous = selectedTab
                selectedTab = t
            }
        }
        .fullBackground()
    }

    // 画面本体
    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .home:    MyTextbookView()
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
