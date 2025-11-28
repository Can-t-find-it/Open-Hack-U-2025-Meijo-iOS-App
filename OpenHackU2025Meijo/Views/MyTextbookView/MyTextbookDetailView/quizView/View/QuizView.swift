import SwiftUI

struct QuizView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let title: String
    let questions: [Question]
    
    @State private var currentIndex: Int = 0
    @State private var selectedChoiceIndex: Int? = nil
    @State private var currentStatementIndex: Int = 0
    @State private var isAnswered: Bool = false
    @State private var isCorrect: Bool? = nil
    
    // 🔽 追加：結果用
    @State private var correctCount: Int = 0
    @State private var isFinished: Bool = false
    
    private var currentQuestion: Question {
        questions[currentIndex]
    }
    
    private var currentStatement: QuestionStatement? {
        let statements = currentQuestion.questionStatements
        guard statements.indices.contains(currentStatementIndex) else { return nil }
        return statements[currentStatementIndex]
    }
    
    var body: some View {
        Group {
            if isFinished {
                resultView
            } else {
                quizView
            }
        }
        .fullBackground()
        .navigationBarHidden(true)
        .onAppear {
            // 最初の問題でランダムにステートメントを選ぶ
            if !questions.isEmpty && !questions[0].questionStatements.isEmpty {
                currentStatementIndex = Int.random(
                    in: 0..<questions[0].questionStatements.count
                )
            }
        }
    }
    
    // MARK: - クイズ画面本体
    private var quizView: some View {
        VStack {
            // MARK: - ヘッダー
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text(title)
                        .font(.headline).fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(currentIndex + 1) / \(questions.count)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                ProgressView(value: Double(currentIndex + 1),
                             total: Double(questions.count))
                    .progressViewStyle(.linear)
                    .tint(.white)
                    .padding(.top, 8)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemPink).opacity(0.5),
                                               Color(.systemPink).opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // MARK: - 問題 & 選択肢エリア
            VStack(spacing: 24) {
                
                // 問題カード
                VStack(spacing: 8) {
                    Text("問題")
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.subheadline)
                    
                    Text(currentStatement?.questionStatement ?? "問題文がありません")
                        .foregroundStyle(.white)
                        .font(.title2).fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .cardBackground()
                
                // 選択肢カード
                VStack(alignment: .leading, spacing: 16) {
                    Text("選択肢から答えを選んでください")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                    
                    if let choices = currentStatement?.choices, !choices.isEmpty {
                        VStack(spacing: 12) {
                            ForEach(Array(choices.enumerated()), id: \.offset) { index, choice in
                                choiceRow(index: index, text: choice)
                            }
                        }
                    } else {
                        Text("この問題には選択肢が設定されていません")
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    // 正解 / 不正解 表示
                    if let isCorrect = isCorrect, isAnswered {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(isCorrect ? "正解！ 🎉" : "不正解…")
                                .font(.headline)
                                .foregroundStyle(isCorrect ? Color.green : Color.red)
                            
                            // 解説
                            if let explain = currentStatement?.explain, !explain.isEmpty {
                                Text("解説")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                                
                                Text(explain)
                                    .font(.footnote)
                                    .foregroundStyle(.white.opacity(0.9))
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // MARK: - ボタンエリア
            VStack(spacing: 12) {
                // 回答するボタン
                if !isAnswered {
                    Button {
                        checkAnswer()
                    } label: {
                        Text("回答する")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedChoiceIndex == nil
                                        ? Color.white.opacity(0.2)
                                        : Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(selectedChoiceIndex == nil)
                }
                
                // 次の問題ボタン
                if isAnswered {
                    Button {
                        goToNextQuestion()
                    } label: {
                        Text(currentIndex == questions.count - 1 ? "結果を見る" : "次の問題へ")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.pink)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
    
    // MARK: - 結果画面
    private var resultView: some View {
        VStack {
            // ヘッダー（同じ見た目）
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline).fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Color.clear
                    .frame(width: 24, height: 24)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemPink).opacity(0.5),
                                               Color(.systemPink).opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            Spacer()
            
            let progress = questions.isEmpty
                ? 0.0
                : Double(correctCount) / Double(questions.count)
            
            CircularProgressView(progress: progress)
                .frame(width: 200, height: 200)
                .padding(.bottom, 16)
            
            Text("正解数 \(correctCount) / \(questions.count)")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.9))
            
            Text("おつかれさまでした！")
                .foregroundStyle(.white.opacity(0.8))
                .padding(.top, 8)
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("閉じる")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .foregroundColor(.pink)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - 選択肢1行のView
    @ViewBuilder
    private func choiceRow(index: Int, text: String) -> some View {
        let label = ["A", "B", "C", "D"]
        let prefix = index < label.count ? label[index] : "\(index + 1)"
        
        Button {
            if !isAnswered {
                selectedChoiceIndex = index
            }
        } label: {
            HStack {
                Text(prefix)
                    .font(.headline)
                    .frame(width: 24)
                
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if selectedChoiceIndex == index && !isAnswered {
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .foregroundStyle(.white)
            .background(backgroundColorForChoice(index: index))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 背景色ロジック
    private func backgroundColorForChoice(index: Int) -> Color {
        guard let statement = currentStatement,
              let choices = statement.choices
        else {
            return Color.white.opacity(0.1)
        }
        
        // まだ回答していないとき
        if !isAnswered {
            if selectedChoiceIndex == index {
                return Color.white.opacity(0.25)
            } else {
                return Color.white.opacity(0.1)
            }
        }
        
        // 回答後は正誤を色で表示
        let correctIndex = choices.firstIndex(of: currentQuestion.answer)
        
        if index == correctIndex {
            return Color.green.opacity(0.4) // 正解
        }
        if index == selectedChoiceIndex && index != correctIndex {
            return Color.red.opacity(0.4) // 選んだが不正解
        }
        return Color.white.opacity(0.1)
    }
    
    // MARK: - 回答チェック
    private func checkAnswer() {
        guard
            let statement = currentStatement,
            let choices = statement.choices,
            let selectedIndex = selectedChoiceIndex
        else { return }
        
        let selectedChoice = choices[selectedIndex]
        let result = (selectedChoice == currentQuestion.answer)
        
        if result {
            correctCount += 1
        }
        
        isCorrect = result
        isAnswered = true
    }
    
    // MARK: - 次の問題へ
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            
            // 状態リセット
            selectedChoiceIndex = nil
            isAnswered = false
            isCorrect = nil
            
            // ランダムな statement を選ぶ
            if !questions[currentIndex].questionStatements.isEmpty {
                currentStatementIndex = Int.random(
                    in: 0..<questions[currentIndex].questionStatements.count
                )
            }
        } else {
            // 最後の問題なら結果画面へ
            isFinished = true
        }
    }
}

// MARK: - 円形プログレスビュー
struct CircularProgressView: View {
    let progress: Double   // 0.0 ... 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 16)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            VStack {
                Text("\(Int(progress * 100))%")
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                Text("正解率")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .animation(.easeOut(duration: 0.6), value: progress)
    }
}

// MARK: - プレビュー用 Mock（Question / QuestionStatement は既存定義を利用）
#Preview {
    let mockQuestions: [Question] = [
        Question(
            id: "q1",
            questionStatements: [
                QuestionStatement(
                    id: "qs1",
                    questionStatement: "SwiftUIで画面を定義する構造体はどれ？",
                    choices: ["UIView", "ViewController", "View", "SceneDelegate"],
                    explain: "SwiftUIでは、画面は `View` プロトコルに準拠した構造体として定義します。"
                ),
                QuestionStatement(
                    id: "qs2",
                    questionStatement: "SwiftUIで画面を定義する構造体はどれ？",
                    choices: ["UIView", "ViewController", "View", "SceneDelegate"],
                    explain: "SwiftUIでは、画面は `View` プロトコルに準拠した構造体として定義します。"
                )
            ],
            answer: "View"
        ),
        Question(
            id: "q2",
            questionStatements: [
                QuestionStatement(
                    id: "qs3",
                    questionStatement: "@State の用途として正しいものは？",
                    choices: ["定数定義", "ローカル変数", "画面の状態管理", "データモデル定義"],
                    explain: "`@State` はView内部で状態を管理するためのプロパティラッパーです。"
                )
            ],
            answer: "画面の状態管理"
        )
    ]
    
    QuizView(title: "SwiftUI クイズ", questions: mockQuestions)
}
