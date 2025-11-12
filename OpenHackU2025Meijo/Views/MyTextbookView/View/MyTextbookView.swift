import SwiftUI
import AppColorTheme

struct MyTextbookView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(0..<12, id: \.self) { _ in
                            TextbookCardView(
                                title: "テキスト名",
                                questionCount: 10,
                                formatLabel: "問題形式"
                            )
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("問題集一覧")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("編集")
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.white)
                }
            }

            .fullBackground()
        }
    }
}

#Preview {
    MyTextbookView()
}
