import SwiftUI
import AppColorTheme

struct TextbooksCardView: View {
    var title: String
    var textbookCount: Int
    var progress: Int
    
    private var progressRatio: Double {
        guard textbookCount > 0 else { return 0 }
        // 0〜textbookCount の範囲にクランプしておくとより安全
        let clamped = min(max(progress, 0), textbookCount)
        return Double(clamped) / Double(textbookCount)
    }
    
    private var percentageText: String {
        let percentage = Int(progressRatio * 100)
        return "\(percentage)%"
    }
    
    var body: some View {
        VStack {
            Image(systemName: "books.vertical")
                .foregroundStyle(.white)
                .font(.system(size: 40))
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            HStack {
                Text("\(textbookCount)冊")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                ProgressView(value: Double(progress), total: Double(textbookCount))
                    .progressViewStyle(.linear)
                    .tint(.pink)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                Text(percentageText)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal)
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

#Preview {
    TextbooksCardView(title: "基本情報技術者", textbookCount: 5, progress: 5)
        .background {
            Color.black
        }
}


#Preview {
    TopView()
}
