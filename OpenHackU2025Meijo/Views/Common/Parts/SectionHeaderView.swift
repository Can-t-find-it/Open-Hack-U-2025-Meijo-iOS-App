import SwiftUI

struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
