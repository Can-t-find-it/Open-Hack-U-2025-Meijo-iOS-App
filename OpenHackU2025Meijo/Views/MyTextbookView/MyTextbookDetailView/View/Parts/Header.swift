import SwiftUI

struct TextbookDetailViewHeader: View {
    let title: String
    let onBack: () -> Void
    
    @State private var showDeleteTextbookAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    showDeleteTextbookAlert = true
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.pink).opacity(0.5),
                    Color(.pink).opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .alert("この問題集を削除しますか？",
               isPresented: $showDeleteTextbookAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("削除", role: .destructive) {
                onBack()
            }
        }
    }
}
