import SwiftUI

struct FriendProgressCard: View {
    let userName: String
    let textbookName: String
    let textbookId: String
    let dateTime: String
    let progress: Double
    let todayProgress: Int
    
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
                
//                Image(systemName: "ellipsis")
//                    .font(.title2)
//                    .foregroundStyle(.gray)
            }
            .padding(.horizontal)
            
            VStack {
                Text("本日の進捗 \(todayProgress) / 3")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                
                HStack {
                    Spacer()
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
                    
                    Spacer()
                    
                    NavigationLink {
                        FriendTextbookView(userName: userName, textName: textbookName, textId: textbookId)
                    } label: {
                        VStack {
                            Text(textbookName)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(width: 100, height: 150)
                        .cardBackground()
                    }
                    
                    Spacer()
                }
            }
            
//            // リアクションエリア
//            HStack {
//                HStack(spacing: 4) {
//                    Image(systemName: "hand.thumbsup")
//                        .foregroundStyle(.gray)
//                    Text("\(goodCount)")
//                        .foregroundStyle(.gray)
//                }
//                
//                HStack(spacing: 4) {
//                    Image(systemName: "hand.thumbsdown")
//                        .foregroundStyle(.gray)
//                    Text("\(badCount)")
//                        .foregroundStyle(.gray)
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//            .padding(.horizontal)
        }
    }
}

struct SkeletonFriendProgressCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 上段：アイコン + 名前 + 日付
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 6) {
                    // ユーザー名っぽい棒
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 120, height: 12)

                    // 日付 or サブ情報
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 80, height: 10)
                }

                Spacer()
            }

            // 中段：テキスト名
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.3))
                .frame(width: 180, height: 12)

            // 下段：進捗バー
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.18))
                .frame(height: 8)

            // 今日の進捗などを表現する小さい棒
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 60, height: 10)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 10)

                Spacer()
            }
        }
        .padding(12)
        .cardBackground()         // あなたの Modifier 前提
        .shimmer()
    }
}

/// ログ一覧全体の Skeleton
struct SkeletonFriendsLogListView: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<6) { index in
                SkeletonFriendProgressCard()

                if index != 5 {
                    Divider()
                        .background(Color.white.opacity(0.5))
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    FriendsLogView()
}
