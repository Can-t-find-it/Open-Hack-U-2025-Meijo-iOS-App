import SwiftUI

struct PostCard: View {
    let username: String
    let timestamp: String
    let description: String
    let likes: Int
    let comments: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.pink)
                            .font(.system(size: 30))
                    }
                
                VStack(alignment: .leading) {
                    Text(username)
                        .font(.title2).fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(timestamp)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding()
            
            // Body
            Text(description)
                .padding(.horizontal)
                .font(.title2)
                .foregroundStyle(.white)
            
            // Footer
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "heart")
                        .foregroundStyle(.gray)
                    Text("\(likes)")
                        .foregroundStyle(.gray)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "bubble")
                        .foregroundStyle(.gray)
                    Text("\(comments)")
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Image(systemName: "bookmark")
                    .foregroundStyle(.gray)
            }
            .padding()
        }
        .cardBackground()
        .padding(.horizontal)
    }
}

extension View {
    func cardBackground(
        cornerRadius: CGFloat = 20,
        lineWidth: CGFloat = 1,
        strokeOpacity: Double = 0.2,
        fillOpacity: Double = 0.1
    ) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.white.opacity(strokeOpacity), lineWidth: lineWidth)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(fillOpacity))
                )
        )
    }
}
