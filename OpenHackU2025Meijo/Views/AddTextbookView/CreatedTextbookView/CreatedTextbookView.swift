import SwiftUI

struct CreatedTextbookView: View {
    let textbook: GeneratedTextbook
    
    @Binding var selectedTab: Tab
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - ヘッダー（タイトルのみ）
            HStack {
                Spacer()
                
                Text(textbook.name)
                    .font(.headline.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.pink.opacity(0.5),
                        Color.pink.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // MARK: - 本文（スクロール）
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("問題一覧")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                    
                    GeneratedQuestionList(questions: textbook.questions)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            
            // MARK: - 一番下の「閉じる」ボタン
            Button {
                selectedTab = .home
                dismiss()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .background(Color.blue.opacity(0.85))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .fullBackground()
        .tabBarHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}


// MARK: - Generated 用の QuestionList

struct GeneratedQuestionList: View {
    let questions: [GeneratedQuestion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(questions) { question in
                GeneratedQuestionCard(question: question)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - GeneratedQuestion 1問分のカード

private struct GeneratedQuestionCard: View {
    let question: GeneratedQuestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - 問題エリア
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
                    ForEach(
                        Array(question.questionStatements.enumerated()),
                        id: \.element.id
                    ) { index, statement in
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("問題文\(index + 1)：\(statement.questionStatement)")
                                .foregroundStyle(.white)
                            
                            // 4択があれば表示
                            if !statement.choices.isEmpty {
                                VStack(alignment: .leading, spacing: 2) {
                                    ForEach(statement.choices.indices, id: \.self) { i in
                                        Text("\(i + 1). \(statement.choices[i])")
                                            .font(.subheadline)
                                            .foregroundStyle(.white.opacity(0.6))
                                    }
                                }
                                .padding(.top, 4)
                            }
                            
                            Text("解説：\(statement.explanation)")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // MARK: - 解答エリア
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
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
    }
}

//
//#Preview {
//    let mockStatement = GeneratedQuestionStatement(
//        id: "s1",
//        questionStatement: "テスト問題です",
//        choices: ["A", "B", "C", "D"],
//        explanation: "これはテスト用の解説です。"
//    )
//    
//    let mockQuestion = GeneratedQuestion(
//        id: "q1",
//        questionStatements: [mockStatement],
//        answer: "A"
//    )
//    
//    let mockTextbook = GeneratedTextbook(
//        id: "t1",
//        name: "サンプル問題集",
//        type: "4択問題形式",
//        questions: [mockQuestion]
//    )
//    
//    // ← return は書かない、最後の行だけ View
//    CreatedTextbookView(
//        textbook: mockTextbook,
//        selectedTab: .constant(.add)
//    )
//}

extension UIApplication {
    func dismissToRoot() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let root = window.rootViewController else { return }
        
        // モーダルを全部閉じる
        root.dismiss(animated: true)
        
        // NavigationStack を root に戻す
        root.navigationController?.popToRootViewController(animated: true)
    }
}

#Preview {
    AddTextbookView(selectedTab: .constant(.add))
}
