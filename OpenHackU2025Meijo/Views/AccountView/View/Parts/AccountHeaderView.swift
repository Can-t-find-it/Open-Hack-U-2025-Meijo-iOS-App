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

struct SkeletonAccountHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 上段：アイコン＋名前
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.system(size: 28))
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 140, height: 16)   // ユーザー名っぽい
                
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 200, height: 12)   // メール or 一言コメントっぽい
                }
                
                Spacer()
            }
            
            // 下段：合計時間・今日の時間などのカード3つくらい
            HStack(spacing: 12) {
                ForEach(0..<3) { _ in
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 40, height: 12)   // ラベル
                
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.35))
                            .frame(width: 60, height: 14)   // 値
                
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 50, height: 10)   // サブテキスト
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.08))
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
        )
        .shimmer()  // ← 既存の shimmer() Modifier をそのまま利用
    }
}


#Preview {
    AccountView()
}
