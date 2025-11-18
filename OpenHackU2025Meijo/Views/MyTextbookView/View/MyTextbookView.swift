import SwiftUI
import AppColorTheme

struct MyTextbookView: View {
    @Binding var isTabBarHidden: Bool
    @State private var viewModel = MyTextbookViewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(viewModel.myTextbooks, id: \.id) { myTextbook in
                            NavigationLink {
                                MyTextbookDetailView(textbook: myTextbook)
                                    .onAppear {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                            isTabBarHidden = true
                                        }                                    }
                                    .onDisappear {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                            isTabBarHidden = false
                                        }
                                    }
                            } label: {
                                TextbookCardView(
                                    title: myTextbook.name,
                                    questionCount: viewModel.questionCount(of: myTextbook),
                                    questionType: myTextbook.questionType.rawValue
                                )
                            }
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
    MyTextbookView(isTabBarHidden: .constant(false))
}

#Preview {
    TopView()
}
