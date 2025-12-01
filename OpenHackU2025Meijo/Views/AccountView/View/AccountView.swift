import SwiftUI

struct AccountView: View {
    @State private var viewModel = AccountViewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    SectionHeaderView(title: "アカウント情報")
                    
                    AccountHeaderView(
                        userName: viewModel.userName,
                        textbookCount: viewModel.textbookCount,
                        streakDays: viewModel.streakDays,
                        friendCount: viewModel.friendCount
                    )
                    
                    HStack {
                        Text("学習履歴")
                            .foregroundStyle(.white)
                    }
                    .padding(.top)
                    
                    Divider()
                        .background(Color.white)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.logs) { log in
                            StudyLogRowView(log: log)
                            
                            Divider()
                                .background(Color.white)
                        }
                    }
                }
            }
            .fullBackground()
            .task {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    AccountView()
}
