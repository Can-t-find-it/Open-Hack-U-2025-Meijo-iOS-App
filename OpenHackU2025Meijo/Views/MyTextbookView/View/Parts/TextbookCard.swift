import SwiftUI
import AppColorTheme

struct TextbookCardView: View {
    var title: String
    var questionType: String

    var body: some View {
        VStack {
            Image(systemName: "book.closed")
                .foregroundStyle(.white)
                .font(.system(size: 40))
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            ZStack {
                Capsule()
                    .fill(Color.white)
                    .frame(width: 90, height: 16)
                
                Text(questionType)
                    .foregroundColor(AppColorToken.background.surface)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),
                    Color.pink.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.4), lineWidth: 1)
        )
    }
}

struct SkeletonTextbookCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // タイトルの代わりの棒
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 120, height: 16)
            
            // サブ情報（問題数など）の棒
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 14)
            
            // プログレスバーの代わり
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 10)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 130)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.15))
        )
        .shimmer()
    }
}

#Preview {
    TextbookCardView(title: "テキスト名", questionType: "問題形式")
        .padding()
        .background(Color.black)
}

#Preview {
    TopView()
}
