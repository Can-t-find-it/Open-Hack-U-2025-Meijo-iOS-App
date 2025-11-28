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
                    
                    QuestionList(questions: viewModel.textbook.questions)
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
            print("\(viewModel.textbook)")
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
            .font(.subheadline)
            .foregroundStyle(.blue)

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
                    let validWords = newWords
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }

                    guard !validWords.isEmpty else { return }

                    viewModel.addGeneratedQuestions(from: validWords)

                    withAnimation {
                        isAddingQuestions = false
                        newWords = [""]
                    }
                } label: {
                    Image(systemName: "sparkles")
                    Text("問題を生成")
                }
                .padding(.horizontal)

            }
            .padding(.top, 4)
        }
        .padding()
        .cardBackground()
    }

}


#Preview {
    MyTextbookDetailView(textName: "基本情報技術者試験", textId: "11")
}
#Preview {
    MyTextbookDetailView(textName: "基本情報技術者試験", textId: "57385638")
}
