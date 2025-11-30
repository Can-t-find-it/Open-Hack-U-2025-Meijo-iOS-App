import SwiftUI

struct FriendTextbooksSectionView: View {
    let friend: FriendTextbooks
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.pink)
                            .font(.system(size: 30))
                    }
                
                Text(friend.userName)
                    .font(.title2).fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
//                Image(systemName: "ellipsis")
//                    .font(.title2)
//                    .foregroundStyle(.gray)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(friend.textbooks) { textbook in
                        NavigationLink {
                            FriendTextbookView(
                                userName: friend.userName,
                                textName: textbook.name,
                                textId: textbook.id
                            )
                        } label: {
                            VStack {
                                Spacer()
                                
                                Text(textbook.name)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity)
                                
                                Spacer()
                                
                                Text("\(textbook.questionCount)問")
                                    .foregroundStyle(.gray)
                                    .padding(.bottom)
                            }
                            .frame(width: 100, height: 150)
                            .cardBackground()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            Divider()
                .background(.white.opacity(0.4))
                .padding(.horizontal)
        }
    }
}

#Preview {
    SearchTextbookView()
}
