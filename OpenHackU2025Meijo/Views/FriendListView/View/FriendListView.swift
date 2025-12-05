import SwiftUI
import AppColorTheme

// MARK: - メイン View

struct FriendListView: View {
    enum Mode {
        case friends     // 友達一覧
        case search      // ユーザー検索
    }
    
    @State private var mode: Mode = .friends
    @State private var viewModel = FriendListViewViewModel()
    
    var body: some View {
        VStack {
            // タイトル
            SectionHeaderView(title: "フレンド")
            
            // MARK: - モード切り替え（SignInView と同じスタイル）
            HStack {
                modeButton(.friends, title: "友達一覧")
                modeButton(.search, title: "ユーザー検索")
            }
            .padding(.top, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - コンテンツ切り替え
                    switch mode {
                    case .friends:
                        friendsSection
                    case .search:
                        searchSection
                    }
                }
            }
        }
        .padding()
        .fullBackground()
        .task {
            await viewModel.loadFriends()
        }
    }
    
    // MARK: - 友達一覧
    
    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("あなたのフレンド")
                .font(.headline)
                .foregroundStyle(.white)
            
            if viewModel.isLoadingFriends {
                HStack {
                    ProgressView()
                        .tint(.white)
                    Text("読み込み中…")
                        .foregroundStyle(.white)
                }
                .padding(.top, 8)
            } else if let error = viewModel.friendsErrorMessage {
                VStack(alignment: .leading, spacing: 4) {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.footnote)
                    Button("再読み込み") {
                        Task {
                            await viewModel.loadFriends()
                        }
                    }
                    .font(.footnote.bold())
                    .foregroundStyle(.blue)
                }
                .padding(.top, 8)
            } else if viewModel.friends.isEmpty {
                Text("まだフレンドがいません。ユーザー検索からフレンドを追加してみましょう。")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                    .padding(.top, 8)
            } else {
                ForEach(viewModel.friends) { friend in
                    FriendRowView(friend: friend)
                    Divider()
                        .background(Color.white.opacity(0.2))
                }
            }
        }
    }
    
    // MARK: - ユーザー検索
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ユーザー検索")
                .font(.headline)
                .foregroundStyle(.white)
            
            HStack {
                TextField("ユーザー名やIDで検索", text: $viewModel.query)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.08))
                    )
                    .foregroundStyle(.white)
                    .onSubmit {
                        Task { await viewModel.search() }
                    }
                
                Button {
                    Task { await viewModel.search() }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                        .foregroundStyle(.white)
                }
            }
            
            if viewModel.isSearching {
                HStack {
                    ProgressView()
                        .tint(.white)
                    Text("検索中…")
                        .foregroundStyle(.white)
                }
            }
            
            if let error = viewModel.searchErrorMessage {
                VStack(alignment: .leading, spacing: 4) {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.footnote)
                    Button("再検索") {
                        Task { await viewModel.search() }
                    }
                    .font(.footnote.bold())
                    .foregroundStyle(.blue)
                }
            }
            
            if !viewModel.searchResults.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("検索結果")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    ForEach(viewModel.searchResults) { user in
                        FriendSearchRowView(user: user) {
                            Task {
                                await viewModel.sendFriendRequest(to: user)
                            }
                        }
                        Divider()
                            .background(Color.white.opacity(0.2))
                    }
                }
            } else if !viewModel.query.isEmpty,
                      !viewModel.isSearching,
                      viewModel.searchErrorMessage == nil {
                Text("該当するユーザーが見つかりませんでした。")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
    }
    
    // MARK: - タブ用のボタン（SignInView 風）

    private func modeButton(_ target: Mode, title: String) -> some View {
        Button {
            mode = target
        } label: {
            VStack(spacing: 4) {
                Text(title)
                    .foregroundColor(mode == target ? .blue : .gray)
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(mode == target ? .blue : .clear)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Row Views

struct FriendRowView: View {
    let friend: FriendData
    
    var body: some View {
        HStack {
            Text(friend.userName)
                .foregroundStyle(.white)
                .font(.headline)
            
            Spacer()
            
            Text("フレンド")
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .stroke(Color.green.opacity(0.8), lineWidth: 1)
                )
                .foregroundStyle(.green)
        }
        .padding(.vertical, 4)
    }
}

struct FriendSearchRowView: View {
    let user: FriendSearchResult
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(user.userName)
                    .foregroundStyle(.white)
                    .font(.headline)
                Text("ID: \(user.id)")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            
            Spacer()
            
            if user.isFriend {
                Text("フレンド")
                    .font(.subheadline.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .stroke(Color.green.opacity(0.8), lineWidth: 1)
                    )
                    .foregroundStyle(.green)
            } else {
                Button(action: onAdd) {
                    Text("追加")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.9))
                        )
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FriendListView()
}
