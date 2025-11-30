import SwiftUI

struct FriendTextbookView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var viewModel: FriendTextbookDetailViewViewModel
    
    let userName: String
    let textName: String
    let textId: String
    
    init(userName: String, textName: String, textId: String) {
        self.userName = userName
        self.textName = textName
        self.textId = textId
        _viewModel = State(initialValue: FriendTextbookDetailViewViewModel(textId: textId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                ZStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text(userName)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    Text(textName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.pink).opacity(0.5),
                        Color(.pink).opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // MARK: - 本文
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding()
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .padding()
                    } else {
                        ForEach(viewModel.textbook.questions) { question in
                            questionCard(question: question)
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .fullBackground()
        .tabBarHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .bottom)
        .task {
            await viewModel.load()
        }
    }
    
    // MARK: - 1問分のカード（QuestionList を使わずに埋め込み）
    @ViewBuilder
    private func questionCard(question: Question) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // ---- 問題 ----
            HStack(alignment: .top, spacing: 8) {
                Text("問題")
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.pink.opacity(0.8))
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(question.questionStatements.enumerated()), id: \.element.id) { index, statement in
                        
                        HStack {
                            Text("問題文\(index + 1)：\(statement.questionStatement)")
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
                        if let choices = statement.choices {
                            VStack(alignment: .leading, spacing: 2) {
                                ForEach(choices.indices, id: \.self) { i in
                                    Text("\(i + 1). \(choices[i])")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                            }
                            .padding(.top, 4)
                        }
                        
                        Text("解説：\(statement.explain)")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // ---- 解答 ----
            HStack(alignment: .top, spacing: 8) {
                Text("解答")
                    .foregroundStyle(.pink)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                    )
                
                Text(question.answer)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
    }
}

#Preview {
    FriendTextbookView(userName: "しまけん", textName: "基本情報技術者試験", textId: "11")
}
