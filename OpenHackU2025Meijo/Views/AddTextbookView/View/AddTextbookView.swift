import SwiftUI
import AppColorTheme
import UniformTypeIdentifiers

struct AddTextbookView: View {
    @Binding var selectedTab: Tab
    @State private var textbookName: String = ""
    @State private var isShowingCreateFolderSheet = false
    @State private var isShowingDocumentPicker = false
    @State private var selectedFileURL: URL?
    
    @State private var viewModel = AddTextbookViewViewModel()
    
    @State private var latestGeneratedTextbook: GeneratedTextbook? = nil
    @State private var didFinishGenerate: Bool = false
    @State private var isShowingCreatedTextbookView: Bool = false
    
    enum QuestionFormat: String, CaseIterable {
        case oneQA = "一問一答"
        case fillBlank = "穴埋め"
    }

    enum AnswerMethod: String, CaseIterable {
        case fourChoices = "4択問題"
        case input = "解答入力"
    }
    
    @State private var selectedQuestionFormat: QuestionFormat = .oneQA
    @State private var selectedAnswerMethod: AnswerMethod = .fourChoices
    
    @State private var selectedFolderID: Folder.ID? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                SectionHeaderView(title: "問題集を生成")
                
                titleField
                
                VStack(alignment: .leading, spacing: 24) {
                    questionFormatSection
                    answerMethodSection
                    folderPickerSection
                    filePickerSection
                }
                .padding(.vertical)
                
                createOrConfirmButton
                
                // 生成中プログレス
                if viewModel.isGeneratingTextbook {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("問題集を生成中…")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        ProgressView(value: viewModel.generateProgress)
                            .progressViewStyle(.linear)
                    }
                    .padding(.horizontal, 16)
                }

                Spacer()
            }
            .padding(.horizontal)
            .fullBackground()
            .sheet(isPresented: $isShowingDocumentPicker) {
                DocumentPicker(selectedFileURL: $selectedFileURL)
            }
            .sheet(isPresented: $isShowingCreateFolderSheet) {
                CreateFolderView {
                    Task {
                        await viewModel.load()
                    }
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
            // 「確認」押下時の遷移
            .navigationDestination(isPresented: $isShowingCreatedTextbookView) {
                if let textbook = latestGeneratedTextbook {
                    CreatedTextbookView(
                        textbook: textbook,
                        selectedTab: $selectedTab
                    )
                } else {
                    EmptyView()
                }
            }
            .task {
                await viewModel.load()
            }
        }
    }
}

// MARK: - Subviews
private extension AddTextbookView {
    var titleField: some View {
        TextField("問題集名を入力", text: $textbookName)
            .padding()
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 16)
    }
    
    var questionFormatSection: some View {
        VStack(alignment: .leading) {
            Text("問題形式")
                .foregroundStyle(.white)
            
            HStack {
                ForEach(QuestionFormat.allCases, id: \.self) { format in
                    let isSelected = (selectedQuestionFormat == format)
                    
                    Button {
                        selectedQuestionFormat = format
                    } label: {
                        Text(format.rawValue)
                            .foregroundStyle(isSelected ? .white : .pink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color.pink.opacity(0.8) : .clear)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.pink.opacity(0.8),
                                            lineWidth: isSelected ? 0 : 1)
                            )
                    }
                }
            }
        }
    }
    
    var answerMethodSection: some View {
        VStack(alignment: .leading) {
            Text("解答方法")
                .foregroundStyle(.white)
            
            HStack {
                ForEach(AnswerMethod.allCases, id: \.self) { method in
                    let isSelected = (selectedAnswerMethod == method)
                    
                    Button {
                        selectedAnswerMethod = method
                    } label: {
                        Text(method.rawValue)
                            .foregroundStyle(isSelected ? .white : .pink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color.pink.opacity(0.8) : .clear)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.pink.opacity(0.8),
                                            lineWidth: isSelected ? 0 : 1)
                            )
                    }
                }
            }
        }
    }
    
    var folderPickerSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("追加先フォルダー選択")
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    isShowingCreateFolderSheet = true
                } label: {
                    Text("追加")
                        .foregroundStyle(.blue)
                }
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.folders) { folder in
                        let isSelected = (selectedFolderID == folder.id)
                        
                        Button {
                            selectedFolderID = folder.id
                        } label: {
                            Text(folder.name)
                                .foregroundStyle(isSelected ? .white : .pink)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color.pink.opacity(0.8) : .clear)
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(Color.pink.opacity(0.8),
                                                lineWidth: isSelected ? 0 : 1)
                                )
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    var filePickerSection: some View {
        VStack(alignment: .leading) {
            Button {
                isShowingDocumentPicker = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    Text("ファイルを追加")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(isFileSelected ? .gray : .blue)
            }
            .disabled(isFileSelected)
            
            if let url = selectedFileURL {
                Text("選択されたファイル: \(url.lastPathComponent)")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
    }
    
    /// 1つのボタンが「生成」→「生成中…」→「確認」と役割を変える
    var createOrConfirmButton: some View {
        Button {
            // 生成中は何もしない
            guard !viewModel.isGeneratingTextbook else { return }
            
            // すでに生成済み & データあり → 確認画面へ遷移
            if didFinishGenerate,
               let _ = latestGeneratedTextbook {
                isShowingCreatedTextbookView = true
                return
            }
            
            // ここから「新規生成」の処理
            guard
                let folderID = selectedFolderID,
                let fileURL = selectedFileURL
            else { return }

            let folderIdString = String(describing: folderID)

            Task { @MainActor in
                // 新しく生成するときは前の結果をリセット
                didFinishGenerate = false
                latestGeneratedTextbook = nil
                
                // 問題集生成（完了後、viewModel.generatedTextbook に入る）
                await viewModel.createTextbook(
                    name: textbookName,
                    type: selectedType,
                    folderId: folderIdString,
                    fileURL: fileURL
                )
                
                // 成功していればローカル状態にコピーして「確認」モードへ
                if let textbook = viewModel.generatedTextbook {
                    latestGeneratedTextbook = textbook
                    didFinishGenerate = true
                }
            }
        } label: {
            Text(buttonTitle)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding(.vertical, 12)
                .background(createButtonBackgroundColor)
                .cornerRadius(5)
                .padding()
        }
        .disabled(disableButton)
    }
}

// MARK: - Logic helpers
private extension AddTextbookView {
    var isTextbookNameValid: Bool {
        !textbookName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isFolderSelected: Bool {
        selectedFolderID != nil
    }

    var isFileSelected: Bool {
        selectedFileURL != nil
    }

    var canCreateTextbook: Bool {
        isTextbookNameValid && isFolderSelected && isFileSelected
    }
    
    var selectedType: String {
        switch (selectedQuestionFormat, selectedAnswerMethod) {
        case (.oneQA, .fourChoices):
            return "4択問題形式"
        case (.oneQA, .input):
            return "入力形式"
        case (.fillBlank, .fourChoices):
            return "穴埋めの4択"
        case (.fillBlank, .input):
            return "穴埋め入力"
        }
    }
    
    /// ボタンのタイトルを状態に応じて変える
    var buttonTitle: String {
        if viewModel.isGeneratingTextbook {
            return "生成中…"
        } else if didFinishGenerate && latestGeneratedTextbook != nil {
            return "作った問題集を確認"
        } else {
            return "問題集を生成"
        }
    }
    
    /// ボタンの背景色
    var createButtonBackgroundColor: Color {
        if viewModel.isGeneratingTextbook {
            return Color.gray.opacity(0.8)
        }
        if didFinishGenerate && latestGeneratedTextbook != nil {
            return Color.pink.opacity(0.9)
        }
        return canCreateTextbook ? Color.blue.opacity(0.8) : Color.gray.opacity(0.8)
    }
    
    /// disable 条件
    var disableButton: Bool {
        if viewModel.isGeneratingTextbook {
            // 生成中は常に押せない
            return true
        }
        if didFinishGenerate && latestGeneratedTextbook != nil {
            // 生成済み → 確認ボタンとして常に押せる
            return false
        }
        // それ以外（まだ生成していないとき）は入力が揃うまで押せない
        return !canCreateTextbook
    }
}



struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedFileURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data], asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedFileURL = urls.first
            print("選択されたファイル: \(urls.first?.lastPathComponent ?? "なし")")
            parent.dismiss()
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("キャンセルされました")
            parent.dismiss()
        }
    }
}

#Preview {
    AddTextbookView(selectedTab: .constant(.add))
}

