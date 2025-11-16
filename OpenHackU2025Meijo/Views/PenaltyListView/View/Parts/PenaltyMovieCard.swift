import SwiftUI

struct PenaltyMovieCard: View {
    var username: String
    var timestamp: String

    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 240)
                .cornerRadius(20)
                .overlay {
                    Image(systemName: "arrowtriangle.right.circle.fill")
                        .foregroundStyle(.pink)
                        .font(.title)
                }
            
            HStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.pink)
                            .font(.system(size: 25))
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(username)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    
                    Text(timestamp)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
        }
        .padding()
    }
}
