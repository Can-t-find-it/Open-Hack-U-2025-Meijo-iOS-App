import SwiftUI

struct OthersTextbookView: View {
    
    let progress: Double = 0.67
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    SectionHeaderView(title: "友達の進捗")
                    
                    Divider()
                        .background(.white)
                    
                    FriendProgressCard(progress: 0.79, todayProgress: 2)
                    
                    Divider()
                        .background(.white)
                    
                    FriendProgressCard(progress: progress, todayProgress: 1)
                    
                    Divider()
                        .background(.white)
                }
            }
            .fullBackground()
        }
    }
}

#Preview {
    OthersTextbookView()
}
