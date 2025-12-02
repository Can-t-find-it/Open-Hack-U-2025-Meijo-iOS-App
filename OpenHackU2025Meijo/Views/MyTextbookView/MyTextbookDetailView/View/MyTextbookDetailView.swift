import SwiftUI
import Charts

struct MyTextbookDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var viewModel: MyTextbookDetailViewViewModel
    
    @State private var isAddingQuestions = false
    @State private var newWords: [String] = [""]
    
    let textName: String
    let textId: String
    
    init(textName: String, textId: String) {
        self.textName = textName
        self.textId = textId
        _viewModel = State(initialValue: MyTextbookDetailViewViewModel(textId: textId))
    }
    
    var body: some View {
        VStack {
            TextbookDetailViewHeader(
                title: viewModel.textbook.name,
                onBack: {
                    presentationMode.wrappedValue.dismiss()
                },
                onDelete: {
                    Task {
                        await viewModel.deleteTextbook()
                        await MainActor.run {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            )
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    TextbookScoreChart(data: viewModel.textbook.score)
                    
                    NavigationLink {
                        QuizView(title: textName, questions: viewModel.textbook.questions)
                    } label: {
                        Text("学習開始")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .background(Color.pink.opacity(0.8))
                            .cornerRadius(5)
                    }
                    
                    HStack(spacing: 16) {
                        VStack {
                            Image(systemName: "square.3.layers.3d")
                                .foregroundStyle(.blue)
                            Text("\(viewModel.countQuestion(of: viewModel.textbook)) 問")
                                .foregroundStyle(.white)
                            Text("問題数")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .cardBackground()

                        VStack {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.red)
                            Text("\(viewModel.textbook.times) 回")
                                .foregroundStyle(.white)
                            Text("学習回数")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .cardBackground()

                        VStack {
                            Image(systemName: "chart.bar.xaxis")
                                .foregroundStyle(.green)
                            Text(viewModel.calcAverageScorePercent(of: viewModel.textbook.score))
                                .foregroundStyle(.white)
                            Text("平均")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .cardBackground()
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                            isAddingQuestions.toggle()
                        }
                    } label: {
                        ZStack {
                            Text(isAddingQuestions ? "閉じる" : "問題を追加")
                                .foregroundStyle(.white)

                            HStack {
                                Spacer()
                                Image(systemName: isAddingQuestions ? "chevron.up" : "chevron.down")
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(5)
                    }
                    
                    if isAddingQuestions {
                        addWordsInlineSection
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    QuestionList(
                        questions: viewModel.textbook.questions,
                        onDeleteQuestion: { question in
                            Task {
                                await viewModel.deleteQuestion(questionId: question.id)
                            }
                        },
                        onDeleteStatement: { statement in
                            Task {
                                await viewModel.deleteQuestionStatement(statementId: statement.id)
                            }
                        },
                        onAddStatement: { question in
                            Task {
                                await viewModel.createQuestionStatement(questionId: question.id)
                            }
                        }
                    )
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
    
    private var addWordsInlineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("覚えたい単語を入力")
                .font(.headline)
                .foregroundStyle(.white)

            ForEach(newWords.indices, id: \.self) { index in
                HStack {
                    TextField("例：データベース", text: $newWords[index])
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    
                    if newWords.count > 1 {
                        Button {
                            newWords.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }

            Button {
                newWords.append("")
            } label: {
                Label("単語を追加", systemImage: "plus.circle.fill")
            }
            .font(.headline)
            .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("AIからの提案")
                    .foregroundStyle(.pink)
                    .font(.headline)
                
                if viewModel.suggestedWords.isEmpty {
                    Text("提案はまだありません")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.suggestedWords, id: \.self) { word in
                                Button {
                                    guard !newWords.contains(word) else { return }
                                    
                                    if let emptyIndex = newWords.firstIndex(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
                                        newWords[emptyIndex] = word
                                    } else {
                                        newWords.append(word)
                                    }
                                } label: {
                                    Text(word)
                                        .foregroundStyle(newWords.contains(word) ? .white : .pink)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Group {
                                                if newWords.contains(word) {
                                                    Capsule()
                                                        .fill(Color.pink.opacity(0.8))
                                                } else {
                                                    Capsule()
                                                        .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                                                }
                                            }
                                        )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical)

            HStack {
                Spacer()
                Button("キャンセル") {
                    withAnimation {
                        isAddingQuestions = false
                        newWords = [""]
                    }
                }
                .padding(.horizontal)

                Button {
                    Task {
                        let validWords = newWords
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }

                        guard !validWords.isEmpty else { return }

                        // 非同期で問題生成
                        await viewModel.createQuestion(words: validWords)

                        // UI の更新はメインアクター上で
                        await MainActor.run {
                            withAnimation {
                                isAddingQuestions = false
                                newWords = [""]
                            }
                        }
                    }
                } label: {
                    Image(systemName: "sparkles")
                    Text("問題を生成")
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .cardBackground()
    }

}


#Preview {
    MyTextbookDetailView(textName: "基本情報技術者試験", textId: "11")
}
#Preview {
    TopView()
}
