import SwiftUI
import AppColorTheme

struct CreateTextbookView: View {
    @State private var folderName: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    
                    Text("キャンセル")
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("完了")
                        .foregroundColor(.blue)
                }
                
                Text("問題集作成")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()
            
            VStack {
                
            }
            .frame(width: 180, height: 120)
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
            
            TextField("フォルダー名を入力", text: $folderName)
                .padding()
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 16)
            
            Spacer()
        }
        .background(AppColorToken.background.surface)
    }
}

#Preview {
    CreateTextbookView()
}
