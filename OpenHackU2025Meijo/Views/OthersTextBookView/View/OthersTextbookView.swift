import SwiftUI

struct OthersTextbookView: View {
    
    @State private var viewModel = FriendsStudyLogListViewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    SectionHeaderView(title: "友達の進捗")
                    
                    Divider()
                        .background(.white)
                    
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                                .padding()
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundStyle(.red)
                                .padding()
                        } else if viewModel.logs.isEmpty {
                            Text("友達の学習ログがありません")
                                .foregroundStyle(.white.opacity(0.8))
                                .padding()
                        } else {
                            ForEach(viewModel.logs) { log in
                                FriendProgressCard(
                                    userName: log.friendName,
                                    textbookName: log.textbookName,
                                    textbookId: log.textbookId,
                                    dateTime: log.dateTime,
                                    progress: log.accuracy / 100.0,
                                    todayProgress: log.todayProgress,
                                    likeCount: log.likeCount,
                                    commentCount: log.commentCount
                                )
                                
                                Divider()
                                    .background(.white)
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
            }
            .fullBackground()
            .task {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    OthersTextbookView()
}
