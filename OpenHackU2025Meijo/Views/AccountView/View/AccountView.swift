import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack {
                        HStack {
                            
                            Spacer()
                            
                            Text("アカウント情報")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        HStack(spacing: 24) {
                            Circle()
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(.pink)
                                        .font(.system(size: 50))
                                }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("username")
                                    .foregroundStyle(.white)
                                
                                HStack(spacing: 24) {
                                    VStack {
                                        Text("100")
                                            .foregroundStyle(.white)
                                        Text("問題集")
                                            .foregroundStyle(.white)
                                    }
                                    
                                    VStack {
                                        Text("100")
                                            .foregroundStyle(.white)
                                        Text("継続日数")
                                            .foregroundStyle(.white)
                                    }
                                    
                                    VStack {
                                        Text("100")
                                            .foregroundStyle(.white)
                                        Text("友達")
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .fullBackground()
        }
    }
}

#Preview {
    AccountView()
}
