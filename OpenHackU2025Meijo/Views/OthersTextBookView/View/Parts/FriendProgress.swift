import SwiftUI

struct FriendProgressCard: View {
    let userName: String
    let textbookName: String
    let dateTime: String
    let progress: Double
    let todayProgress: Int
    let likeCount: Int
    let commentCount: Int
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.pink)
                            .font(.system(size: 30))
                    }
                
                VStack(alignment: .leading) {
                    Text(userName)
                        .font(.title2).fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(dateTime)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding()
            
            // 進捗エリア
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 12)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.pink,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(Int(progress * 100))%")
                            .font(.title).bold()
                            .foregroundStyle(.white)
                        Text("正解率")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .frame(width: 100, height: 100)
                
                VStack(spacing: 16) {
                    Text("本日の進捗 \(todayProgress) / 3")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    Text(textbookName) // 問題集名
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .padding()
            }
            
            // リアクションエリア
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "heart")
                        .foregroundStyle(.gray)
                    Text("\(likeCount)")
                        .foregroundStyle(.gray)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "bubble")
                        .foregroundStyle(.gray)
                    Text("\(commentCount)")
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Image(systemName: "arrowshape.down")
                    .foregroundStyle(.gray)
            }
            .padding()
        }
    }
}
