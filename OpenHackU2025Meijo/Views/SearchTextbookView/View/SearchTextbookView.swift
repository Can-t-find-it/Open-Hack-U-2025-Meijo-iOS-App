import SwiftUI

struct SearchTextbookView: View {
    
    @State private var viewModel = FriendsTextbooksViewViewModel()
    
    @State private var isSearchCategory = false
    @State private var isSearchFriend = false
    
    var body: some View {
        NavigationStack {
            VStack {
                SectionHeaderView(title: "友達の問題集一覧")
                
                HStack {
                    Button {
                        isSearchCategory.toggle()
                        if isSearchFriend {
                            isSearchFriend = false
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
                        isSearchFriend.toggle()
                        if isSearchCategory {
                            isSearchCategory = false
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
                                .fill(Color(isSearchFriend ? .pink.opacity(0.8) : .white.opacity(0.2)))
                        )
                    }
                }
                
                // カテゴリー検索チップ
                if isSearchCategory {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.allTextbookNames, id: \.self) { item in
                                Text(item)
                                    .foregroundStyle(Color.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.2))
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 友達検索チップ
                if isSearchFriend {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.allUserNames, id: \.self) { name in
                                Text(name)
                                    .foregroundStyle(Color.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.2))
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 友達の問題集リスト本体
                Group {
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .tint(.white)
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        Text(error)
                            .foregroundStyle(.red)
                            .padding()
                        Spacer()
                    } else if viewModel.friends.isEmpty {
                        Spacer()
                        Text("友達の問題集がありません")
                            .foregroundStyle(.white.opacity(0.8))
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 24) {
                                ForEach(viewModel.friends) { friend in
                                    FriendTextbooksSectionView(friend: friend)
                                }
                            }
                            .padding(.top, 16)
                        }
                    }
                }
                
                Spacer()
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
