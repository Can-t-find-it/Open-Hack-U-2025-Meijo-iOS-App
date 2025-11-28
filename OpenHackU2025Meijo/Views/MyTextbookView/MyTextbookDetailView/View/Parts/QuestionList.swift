import SwiftUI

struct QuestionList: View {
    let questions: [Question]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(questions) { question in
                QuestionCard(question: question)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - 1問ぶんのカード

private struct QuestionCard: View {
    let question: Question
    
    @State private var showDeleteStatementAlert = false   // 問題文削除
    @State private var showDeleteQuestionAlert = false    // 問題削除
    
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
                    // question.questionStatements をナンバリングして表示
                    ForEach(Array(question.questionStatements.enumerated()), id: \.element.id) { index, statement in
                        
                        HStack {
                            Text("問題文\(index + 1)：\(statement.questionStatement)")
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Button {
                                showDeleteStatementAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        // 4択がある場合のみ選択肢を表示
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
                
                
                Button {
                    showDeleteQuestionAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "sparkles")
                Text("問題文を追加")
            }
            .font(.subheadline)
            .foregroundStyle(.blue)
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground() // ← プロジェクトの既存 Modifier を利用
        .alert("この問題文を問題から削除しますか？",
               isPresented: $showDeleteStatementAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("削除", role: .destructive) {
                // 🔥 実際の削除処理（後で実装）
            }
        }
        .alert("この問題を問題集から削除しますか？",
               isPresented: $showDeleteQuestionAlert) {
            Button("キャンセル", role: .cancel) {}
            Button("削除", role: .destructive) {
                // 🔥 問題削除処理（後で実装）
            }
        }
    }
}

//
//#Preview {
//    MyTextbookDetailView(textbook: feMock)
//}
//#Preview {
//    MyTextbookDetailView(textbook: feMockMultiPattern)
//}
