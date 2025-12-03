import SwiftUI

struct FriendTextbooksSectionView: View {
    let friend: FriendTextbooks
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.pink)
                            .font(.system(size: 30))
                    }
                
                Text(friend.userName)
                    .font(.title2).fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
//                Image(systemName: "ellipsis")
//                    .font(.title2)
//                    .foregroundStyle(.gray)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(friend.textbooks) { textbook in
                        NavigationLink {
                            FriendTextbookView(
                                userName: friend.userName,
                                textName: textbook.name,
                                textId: textbook.id
                            )
                        } label: {
                            VStack {
                                Spacer()
                                
                                Text(textbook.name)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity)
                                
                                Spacer()
                                
                                Text("\(textbook.questionCount)問")
                                    .foregroundStyle(.gray)
                                    .padding(.bottom)
                            }
                            .frame(width: 100, height: 150)
                            .cardBackground()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            Divider()
                .background(.white.opacity(0.4))
                .padding(.horizontal)
        }
    }
}

struct SkeletonFriendTextbooksSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)

                
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 120, height: 14)   // 友達名っぽい
                
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 180, height: 12)   // 「問題集 3冊」みたいな位置
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // 横スクロールの問題集カードっぽい Skeleton
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 180, height: 100)
                            .overlay {
                                VStack(alignment: .leading, spacing: 8) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.45))
                                        .frame(width: 120, height: 12)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.3))
                                        .frame(width: 80, height: 10)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.25))
                                        .frame(width: 100, height: 10)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            Divider()
                .background(.white.opacity(0.4))
                .padding(.horizontal)
        }
        .shimmer()      // ← 既存の shimmer() Modifier を利用
    }
}

/// Skeleton セクションを複数並べる
struct SkeletonFriendTextbooksList: View {
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<3) { _ in
                SkeletonFriendTextbooksSectionView()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchTextbookView()
}
