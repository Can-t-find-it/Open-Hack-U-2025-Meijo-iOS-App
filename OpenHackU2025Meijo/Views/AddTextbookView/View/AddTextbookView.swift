import SwiftUI
import AppColorTheme
import UniformTypeIdentifiers

struct AddTextbookView: View {
    @State private var textbookName: String = ""
    @State private var isShowingCreateFolderSheet = false
    @State private var isShowingDocumentPicker = false
    @State private var selectedFileURL: URL?
    
    @State private var viewModel = AddTextbookViewViewModel()
    
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
                
                createButton
                
                Spacer()
            }
            .padding(.horizontal)
            .fullBackground()
            .sheet(isPresented: $isShowingDocumentPicker) {
                DocumentPicker(selectedFileURL: $selectedFileURL)
            }
            .sheet(isPresented: $isShowingCreateFolderSheet) {
                CreateFolderView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
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
    
    var createButton: some View {
        Button {
            guard
                let folderID = selectedFolderID,
                let fileURL = selectedFileURL
            else { return }

            let folderIdString = String(describing: folderID)

            Task {
                await viewModel.createTextbook(
                    name: textbookName,
                    type: selectedType,
                    folderId: folderIdString,
                    fileURL: fileURL
                )
            }
        } label: {
            Text("問題集を生成")
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding(.vertical, 12)
                .background(createButtonBackgroundColor)
                .cornerRadius(5)
                .padding()
        }
        .disabled(!canCreateTextbook)
    }
}

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
    
    var createButtonBackgroundColor: Color {
        let base = canCreateTextbook ? Color.blue : Color.gray
        return base.opacity(0.8)
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
    AddTextbookView()
}
