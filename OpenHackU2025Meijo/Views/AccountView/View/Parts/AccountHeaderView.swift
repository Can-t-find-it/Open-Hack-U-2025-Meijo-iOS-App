import SwiftUI

struct AccountHeaderView: View {
    let userName: String
    let textbookCount: Int
    let streakDays: Int
    let friendCount: Int
    
    var body: some View {
        HStack {
            HStack(spacing: 24) {
                Circle()
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.pink)
                            .font(.system(size: 50))
                    }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(userName)
                        .foregroundStyle(.white)
                        .font(.title2).fontWeight(.bold)
                    
                    HStack(spacing: 24) {
                        VStack {
                            Text("\(textbookCount)")
                                .foregroundStyle(.white)
                            Text("問題集")
                                .foregroundStyle(.white)
                        }
                        
                        VStack {
                            Text("\(streakDays)")
                                .foregroundStyle(.white)
                            Text("継続日数")
                                .foregroundStyle(.white)
                        }
                        
                        VStack {
                            Text("\(friendCount)")
                                .foregroundStyle(.white)
                            Text("友達")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    AccountView()
}
