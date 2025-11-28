import SwiftUI

struct StudyLogRowView: View {
    let log: StudyLog    // ← プロジェクトのログモデル名に合わせて変えてOK

    var body: some View {
        VStack(spacing: 16) {
            // ヘッダー部（アイコン・ユーザー名・日時・…ボタン）
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.pink)
                            .font(.system(size: 30))
                    }
                
                VStack(alignment: .leading) {
                    Text(log.userName)
                        .font(.title3).fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(log.dateTime)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal)
            
            // 正解率サークル & 問題集名
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 8)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(log.accuracy / 100.0))
                        .stroke(
                            Color.pink,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text(String(format: "%.1f%%", log.accuracy))
                            .font(.title2).bold()
                            .foregroundStyle(.white)
                        Text("正解率")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .frame(width: 70, height: 70)
                
                VStack(spacing: 16) {
                    Text(log.textbookName)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .padding()
            }
            
            // いいね・コメント数
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "heart")
                        .foregroundStyle(.gray)
                    
                    Text("\(log.likeCount)")
                        .foregroundStyle(.gray)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "bubble")
                        .foregroundStyle(.gray)
                    
                    Text("\(log.commentCount)")
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AccountView()
}
