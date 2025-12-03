import SwiftUI

struct AccountView: View {
    @State private var viewModel = AccountViewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    SectionHeaderView(title: "アカウント情報")
                    
                    if viewModel.isLoading {
                        // 🔸 ヘッダー Skeleton
                        SkeletonAccountHeaderView()
                    } else {
                        // 🔹 実データヘッダー
                        AccountHeaderView(
                            userName: viewModel.userName,
                            textbookCount: viewModel.textbookCount,
                            streakDays: viewModel.streakDays,
                            friendCount: viewModel.friendCount
                        )
                    }
                    
                    HStack {
                        Text("学習履歴")
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.top)
                    
                    Divider()
                        .background(Color.white)
                    
                    if viewModel.isLoading {
                        // 🔸 ログ Skeleton
                        SkeletonStudyLogListView()
                            .padding(.top, 4)
                    } else if viewModel.logs.isEmpty {
                        Text("まだ学習履歴がありません")
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.top, 8)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(viewModel.logs) { log in
                                StudyLogRowView(log: log)
                                
                                Divider()
                                    .background(Color.white)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .fullBackground()
            .task {
                await viewModel.start()
            }
        }
    }
}
#Preview {
    AccountView()
}
