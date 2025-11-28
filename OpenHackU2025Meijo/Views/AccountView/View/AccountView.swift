import SwiftUI

struct AccountView: View {
    @State private var uerViewModel = AccountViewViewModel()
    @State private var logsViewModel = StudyLogListViewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    VStack {
                        HStack {
                            
                            Spacer()
                            
                            Text("アカウント情報")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    AccountHeaderView(
                        userName: uerViewModel.userName,
                        textbookCount: uerViewModel.textbookCount,
                        streakDays: uerViewModel.streakDays,
                        friendCount: uerViewModel.friendCount
                    )
                    
                    HStack {
                        Text("学習履歴")
                            .foregroundStyle(.white)
                    }
                    .padding(.top)
                    
                    Divider()
                        .background(Color.white)
                    
                    VStack(spacing: 16) {
                        ForEach(logsViewModel.logs) { log in
                            StudyLogRowView(log: log)
                            
                            Divider()
                                .background(Color.white)
                        }
                    }
                }
            }
            .fullBackground()
            .task {
                await uerViewModel.load()
            }
            .task {
                await logsViewModel.load()
            }
        }
    }
}

#Preview {
    AccountView()
}
