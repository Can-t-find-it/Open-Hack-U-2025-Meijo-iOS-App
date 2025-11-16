import SwiftUI

struct PenaltyListView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<5, id: \.self) { index in
                    PenaltyMovieCard(
                        username: "username",
                        timestamp: "timestamp"
                    )
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.3))
                }
            }
        }
        .fullBackground()
    }
}

#Preview {
    PenaltyListView()
}
