import SwiftUI
import Charts

struct MyTextbookDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var viewModel: MyTextbookDetailViewViewModel
    
    @State private var isAddingQuestions = false
    @State private var newWords: [String] = [""]
    @State private var selectedFileURL: URL?
    @State private var isShowingDocumentPicker = false
    @State private var isPdfExtractSended = false
    @State private var isAiSuggestSended = false
    
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
                title: viewModel.textbook.name.isEmpty ? textName : viewModel.textbook.name,
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
                    if viewModel.isLoading {
                        // 🔸 ローディング中：Skeleton 表示
                        SkeletonScoreChartView()
                        SkeletonPrimaryButtonView()
                        HStack(spacing: 16) {
                            SkeletonStatCardView()
                            SkeletonStatCardView()
                            SkeletonStatCardView()
                        }
                        SkeletonToggleButtonView()
                        SkeletonQuestionListView()
                    } else {
                        // 🔹 通常表示
                        TextbookScoreChart(data: viewModel.textbook.score)
                        
                        NavigationLink {
                            QuizView(title: textName, questions: viewModel.textbook.questions, textbookId: textId)
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

                            if isAddingQuestions {
                                // 🔵 開いたとき：入力系を初期化
                                isPdfExtractSended = false
                                isAiSuggestSended = false
                                selectedFileURL = nil
                                newWords = [""]
                                viewModel.pdfWords = []
                                viewModel.suggestedWords = []
                            } else {
                                // 🔴 閉じたとき：AI提案・抽出結果も含めて全部リセット
                                isPdfExtractSended = false
                                isAiSuggestSended = false
                                selectedFileURL = nil
                                newWords = [""]
                                viewModel.pdfWords = []
                                viewModel.suggestedWords = []
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
                            addingStatementQuestionId: viewModel.addingStatementQuestionId,
                            addStatementProgress: viewModel.addStatementProgress,
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
                }
                .padding()
            }
            
            Spacer()
        }
        .fullBackground()
        .tabBarHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker(selectedFileURL: $selectedFileURL)
        }
        .task {
            await viewModel.start()
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
                        .foregroundStyle(.white)
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
                Text("ファイルから単語を抽出")
                    .foregroundStyle(.white)
                    .font(.headline)
                
                HStack {
                    let isDisabled = (selectedFileURL != nil)

                    Button {
                        guard !isDisabled else { return }
                        isShowingDocumentPicker = true
                    } label: {
                        Text("ファイルを選択")
                            .foregroundStyle(isDisabled ? .gray : .blue)
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .overlay(
                                Rectangle()
                                    .stroke(isDisabled ? Color.gray : Color.blue,
                                            lineWidth: 1)
                            )
                    }
                    .disabled(isDisabled)
                    
                    Spacer()
                    
                    let canSend = (selectedFileURL != nil) && !viewModel.isExtractingFromPDF && !isPdfExtractSended

                    Button {
                        Task {
                            guard let fileURL = selectedFileURL else { return }
                            await viewModel.fetchExtractWords(from: fileURL)
                            isPdfExtractSended = true
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title3)
                            Text(viewModel.isExtractingFromPDF ? "送信中…" : "送信")
                                .font(.subheadline)
                                .bold()
                        }
                        .foregroundStyle(canSend ? .white : .gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            canSend
                            ? Color.blue.opacity(0.8)
                            : Color.gray.opacity(0.3)
                        )
                        .cornerRadius(8)
                        .shadow(radius: canSend ? 1 : 0)
                    }
                    .disabled(!canSend)
                }

                
                
                if let url = selectedFileURL {
                    Text("選択されたファイル: \(url.lastPathComponent)")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                }
                
                if viewModel.isExtractingFromPDF {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PDF から単語を抽出中…")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        ProgressView(value: viewModel.extractProgress)
                            .progressViewStyle(.linear)
                    }
                } else if !viewModel.pdfWords.isEmpty {
                    Text("PDF からの抽出が完了しました")
                        .font(.caption)
                        .foregroundStyle(.green.opacity(0.8))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.pdfWords, id: \.self) { word in
                            // すでに newWords に入っているかどうか
                            let isSelected = newWords.contains { $0 == word }
                            
                            Button {
                                // 重複は追加しない
                                guard !isSelected else { return }
                                
                                // 空欄の TextField があればそこに入れる
                                if let emptyIndex = newWords.firstIndex(where: {
                                    $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                }) {
                                    newWords[emptyIndex] = word
                                } else {
                                    // なければ行を追加
                                    newWords.append(word)
                                }
                            } label: {
                                Text(word)
                                    .foregroundStyle(isSelected ? .white : .blue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Group {
                                            if isSelected {
                                                Capsule()
                                                    .fill(Color.blue.opacity(0.8))
                                            } else {
                                                Capsule()
                                                    .stroke(Color.blue.opacity(0.8), lineWidth: 1)
                                            }
                                        }
                                    )
                            }
                        }
                    }
                }

            }
            .padding(.top, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("AIからの提案")
                    .foregroundStyle(.pink)
                    .font(.headline)
                
                // このボタンを押せるかどうか
                let canSendAISuggest = !viewModel.isGeneratingAISuggest && !isAiSuggestSended
                
                Button {
                    Task {
                        guard canSendAISuggest else { return }
                        await viewModel.fetchWordSuggestions()
                        await MainActor.run {
                            isAiSuggestSended = true   // 🔹 1回送信したらロック
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title3)
                        Text(
                            viewModel.isGeneratingAISuggest
                            ? "思考中…"
                            : (isAiSuggestSended ? "生成済み" : "生成")
                        )
                        .font(.subheadline)
                        .bold()
                    }
                    .foregroundStyle(canSendAISuggest ? .white : .gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        canSendAISuggest
                        ? Color.pink
                        : Color.gray.opacity(0.3)   // 🔹 生成後はグレー
                    )
                    .cornerRadius(8)
                    .shadow(radius: canSendAISuggest ? 1 : 0)
                }
                .disabled(!canSendAISuggest)
                
                if viewModel.isGeneratingAISuggest {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("AI が単語を検討中…")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                        ProgressView(value: viewModel.aISuggestProgress)
                            .progressViewStyle(.linear)
                    }
                    .padding(.top, 4)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.suggestedWords, id: \.self) { word in
                            Button {
                                guard !newWords.contains(word) else { return }
                                
                                if let emptyIndex = newWords.firstIndex(where: {
                                    $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                }) {
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
            .padding(.vertical)


            HStack {
                Spacer()
                Button("キャンセル") {
                    withAnimation {
                        isAddingQuestions = false
                        newWords = [""]
                        isPdfExtractSended = false
                        isAiSuggestSended = false            // 🔹 ロック解除
                        selectedFileURL = nil
                        viewModel.pdfWords = []
                        viewModel.suggestedWords = []        // 🔹 提案単語をクリア
                    }
                }
                .padding(.horizontal)
                
                let canGenerate = newWords.contains {
                    !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }

                Button {
                    Task {
                        let validWords = newWords
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }

                        guard !validWords.isEmpty else { return }

                        await viewModel.createQuestion(words: validWords)

                        await MainActor.run {
                            withAnimation {
                                isAddingQuestions = false
                                newWords = [""]
                                isPdfExtractSended = false
                                isAiSuggestSended = false          // 🔹 ロック解除
                                selectedFileURL = nil
                                viewModel.pdfWords = []
                                viewModel.suggestedWords = []      // 🔹 提案単語クリア
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "sparkles")
                        Text(viewModel.isGeneratingQuestions ? "生成中…" : "問題を生成")
                    }
                    .foregroundStyle(
                        (canGenerate && !viewModel.isGeneratingQuestions) ? .blue : .gray
                    )
                }
                .disabled(!canGenerate || viewModel.isGeneratingQuestions)
            }
            
            if viewModel.isGeneratingQuestions {
                VStack(alignment: .trailing, spacing: 6) {
                    Text("問題を生成中…")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    ProgressView(value: viewModel.generateProgress)
                        .progressViewStyle(.linear)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .cardBackground()
    }
}

struct SkeletonPrimaryButtonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.white.opacity(0.2))
            .frame(height: 44)
            .shimmer()
    }
}

/// 下の 3 つの stats カード用 Skeleton（カード1枚）
struct SkeletonStatCardView: View {
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.25))
                .frame(width: 24, height: 24)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.35))
                .frame(width: 40, height: 14)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.25))
                .frame(width: 36, height: 12)
        }
        .frame(maxWidth: .infinity)
        .cardBackground()
        .shimmer()
    }
}

/// 「問題を追加」ボタンの Skeleton
struct SkeletonToggleButtonView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.white.opacity(0.2))
            .frame(height: 44)
            .shimmer()
    }
}


#Preview {
    MyTextbookDetailView(textName: "基本情報技術者試験", textId: "11")
}
#Preview {
    TopView()
}
