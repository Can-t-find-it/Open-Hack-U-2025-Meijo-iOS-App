import SwiftUI

struct SearchTextbookView: View {
    
    @State private var viewModel = FriendsTextbooksViewViewModel()
    
    @State private var isSearchCategory = false
    @State private var isSearchFriend = false
    
    @State private var selectedFriendName: String? = nil
    
    // 友達フィルタ後の配列
    private var filteredFriends: [FriendTextbooks] {
        guard let name = selectedFriendName, !name.isEmpty else {
            return viewModel.friends    // ViewModel 側に friends: [FriendTextbooks] がある前提
        }
        return viewModel.friends.filter { $0.userName == name }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SectionHeaderView(title: "友達の問題集一覧")
                
                // 検索トグルボタン
                HStack {
                    Button {
                        withAnimation {
                            isSearchCategory.toggle()
                            if isSearchCategory {
                                isSearchFriend = false
                            }
                        }
                    } label: {
                        HStack {
                            Text("カテゴリー")
                            Image(systemName: isSearchCategory ? "chevron.up" : "chevron.down")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(isSearchCategory ? .pink.opacity(0.8) : .white.opacity(0.2)))
                        )
                    }
                    
                    Button {
                        withAnimation {
                            isSearchFriend.toggle()
                            if isSearchFriend {
                                isSearchCategory = false
                            }
                        }
                    } label: {
                        HStack {
                            Text("友達")
                            Image(systemName: isSearchFriend ? "chevron.up" : "chevron.down")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(isSearchCategory ? .pink.opacity(0.8) : .white.opacity(0.2)))
                        )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // 友達名フィルタ（上のトグルで開閉）
                if isSearchFriend {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.allUserNames, id: \.self) { name in
                                let isSelected = (selectedFriendName == name)
                                
                                Button {
                                    // 同じ友達をもう一度タップしたら解除（＝全件表示）
                                    if selectedFriendName == name {
                                        selectedFriendName = nil
                                    } else {
                                        selectedFriendName = name
                                    }
                                } label: {
                                    Text(name)
                                        .foregroundStyle(Color.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(
                                                    isSelected
                                                    ? Color.pink.opacity(0.8)
                                                    : Color.white.opacity(0.2)
                                                )
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }
                
                // カテゴリ検索 UI は既存実装があればそこに差し替え
                if isSearchCategory {
                    // ここにカテゴリフィルタ UI を実装済みならそのまま書く
                    // 今はダミーのプレースホルダー
                    Text("カテゴリー検索 UI（実装済みならここに）")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
                
                Divider()
                    .background(.white)
                    .padding(.horizontal)
                
                // MARK: - 本体リスト
                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.isLoading {
                            // 🔸 読み込み中：Skeleton カードを並べる
                            SkeletonFriendTextbooksList()
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundStyle(.red)
                                .padding()
                        } else if filteredFriends.isEmpty {
                            Text("友達の問題集がありません")
                                .foregroundStyle(.white.opacity(0.8))
                                .padding()
                        } else {
                            ForEach(filteredFriends) { friend in
                                FriendTextbooksSectionView(friend: friend)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .fullBackground()
            .ignoresSafeArea(edges: .bottom)
            .task {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    SearchTextbookView()
}
