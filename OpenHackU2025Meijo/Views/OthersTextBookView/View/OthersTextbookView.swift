import SwiftUI

struct OthersTextbookView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<5, id: \.self) { index in
                    PostCard(
                        username: "User \(index + 1)",
                        timestamp: "2025/11/11",
                        description: "This is description for post \(index + 1).",
                        likes: Int.random(in: 50...200),
                        comments: Int.random(in: 10...80)
                    )
                }
            }
            .padding(.vertical)
        }
        .fullBackground()
    }
}

#Preview {
    OthersTextbookView()
}
