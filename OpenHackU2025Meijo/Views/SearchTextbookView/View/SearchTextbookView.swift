import SwiftUI

struct SearchTextbookView: View {
    let selecterItem: [String] = ["基本情報技術者試験", "数学", "歴史", "宅建"]
    let userList: [String] = ["Use1", "Use2", "Use3", "Use4", "User5"]
    
    @State private var isSearchCategory = false
    @State private var isSearchFriend = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                VStack {
                    HStack {
                        
                        Spacer()
                        
                        Text("友達の問題集一覧")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Button {
                        isSearchCategory.toggle()
                        
                        if isSearchFriend {
                            isSearchFriend = false
                        }
                    } label: {
                        HStack {
                            Text("カテゴリー")
                            Image(systemName: isSearchCategory ? "chevron.up" : "chevron.down")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(isSearchCategory ? .pink.opacity(0.8) : .white.opacity(0.2)))
                        )
                    }
                    
                    Button {
                        isSearchFriend.toggle()
                        
                        if isSearchCategory {
                            isSearchCategory = false
                        }
                    } label: {
                        HStack {
                            Text("友達")
                            Image(systemName: isSearchFriend ? "chevron.up" : "chevron.down")
                        }
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(isSearchFriend ? .pink.opacity(0.8) : .white.opacity(0.2)))
                        )
                    }
                }
                
                if isSearchCategory {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(selecterItem, id: \.self) { item in
                                HStack {
                                    Text(item)
                                        .foregroundStyle(Color.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(Color.white.opacity(0.2))
                                        )
                                }
                            }
                        }
                    }
                }
                if isSearchFriend {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(userList, id: \.self) { user in
                                Text(user)
                                    .foregroundStyle(Color.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.2))
                                    )
                            }
                        }
                    }
                }
                
                
                VStack {
                    HStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.pink)
                                    .font(.system(size: 30))
                            }
                        
                        Text("Fuck 上野")
                            .font(.title2).fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            VStack {
                                Text("テキスト名")
                                    .foregroundStyle(.white)
                                
                                Text("10問")
                                    .foregroundStyle(.gray)
                            }
                            .frame(width: 100, height: 150)
                            .cardBackground()
                            
                            VStack {
                                Text("テキスト名")
                                    .foregroundStyle(.white)
                                
                                Text("10問")
                                    .foregroundStyle(.gray)
                            }
                            .frame(width: 100, height: 150)
                            .cardBackground()
                            
                            VStack {
                                Text("テキスト名")
                                    .foregroundStyle(.white)
                                
                                Text("10問")
                                    .foregroundStyle(.gray)
                            }
                            .frame(width: 100, height: 150)
                            .cardBackground()
                            
                            VStack {
                                Text("テキスト名")
                                    .foregroundStyle(.white)
                                
                                Text("10問")
                                    .foregroundStyle(.gray)
                            }
                            .frame(width: 100, height: 150)
                            .cardBackground()
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
                
                Divider()
                    .background(.white)
                
                Spacer()
            }
            .fullBackground()
        }
    }
}

#Preview {
    SearchTextbookView()
}
