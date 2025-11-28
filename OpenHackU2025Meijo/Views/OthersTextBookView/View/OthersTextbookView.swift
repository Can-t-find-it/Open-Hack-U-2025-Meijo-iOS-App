import SwiftUI

struct OthersTextbookView: View {
    
    let progress: Double = 0.67
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack {
                        HStack {
                            
                            Spacer()
                            
                            Text("友達の進捗")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(.white)
                    
                    VStack {
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(.pink)
                                        .font(.system(size: 30))
                                }
                            
                            VStack(alignment: .leading) {
                                Text("Fuck 上野")
                                    .font(.title2).fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("2025 11/28")
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "ellipsis")
                                .font(.title2)
                                .foregroundStyle(.gray)
                        }
                        .padding()
                        
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 12)
                                
                                Circle()
                                    .trim(from: 0, to: progress)
                                    .stroke(
                                        Color.pink,
                                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90))
                                
                                VStack {
                                    Text("\(Int(progress * 100))%")
                                        .font(.title).bold()
                                        .foregroundStyle(.white)
                                    Text("正解率")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                            }
                            .frame(width: 100, height: 100)
                            
                            
                            VStack(spacing: 16) {
                                Text("本日の進捗 1 / 3")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                                
                                Text("基本情報技術者試験A問題") // 問題集名
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                            .padding()
                        }
                    }
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "heart")
                                .foregroundStyle(.gray)
                            Text("9")
                                .foregroundStyle(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "bubble")
                                .foregroundStyle(.gray)
    //                        Text("\(comments)")
    //                            .foregroundStyle(.gray)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Image(systemName: "arrowshape.down")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                }
                
                Divider()
                    .background(.white)
            }
            .fullBackground()
        }
    }
}

//struct OthersTextbookView: View {
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 16) {
//                ForEach(0..<5, id: \.self) { index in
//                    PostCard(
//                        username: "User \(index + 1)",
//                        timestamp: "2025/11/11",
//                        description: "This is description for post \(index + 1).",
//                        likes: Int.random(in: 50...200),
//                        comments: Int.random(in: 10...80)
//                    )
//                }
//            }
//            .padding(.vertical)
//        }
//        .fullBackground()
//    }
//}
#Preview {
    OthersTextbookView()
}
