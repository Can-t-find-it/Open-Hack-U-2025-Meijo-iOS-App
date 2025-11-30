import SwiftUI
import UniformTypeIdentifiers
import AppColorTheme

struct CreateTextbookView: View {
    @State private var textbookName: String = ""
    
    @FocusState private var isTextFieldFocused: Bool

    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingDocumentPicker = false
    @State private var selectedFileURL: URL?
    
    enum QuestionFormat: String, CaseIterable {
        case auto = "おまかせ"
        case oneQA = "一問一答"
        case fillBlank = "穴埋め"
    }

    enum AnswerMethod: String, CaseIterable {
        case auto = "おまかせ"
        case fourChoices = "4択問題"
        case input = "解答入力"
    }

    enum QuestionCount: CaseIterable {
        case auto, few, normal, many
    }
    
    @State private var selectedQuestionFormat: QuestionFormat = .auto
    @State private var selectedAnswerMethod: AnswerMethod = .auto
    @State private var selectedQuestionCount: QuestionCount = .auto

    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("キャンセル")
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Text("完了")
                            .foregroundColor(isTextbookNameValid ? .blue : .gray)
                    }
                    .disabled(!isTextbookNameValid)
                }
                
                Text("問題集作成")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()
            
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
                .focused($isTextFieldFocused)
            
            VStack(alignment: .leading, spacing: 24) {
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

                
                VStack(alignment: .leading) {
                    Text("問題数")
                        .foregroundStyle(.white)
                    
                    HStack {
                        questionCountButton(.auto,
                                            title: "おまかせ",
                                            subtitle: "自動的に設定")
                        
                        questionCountButton(.few,
                                            title: "少なめ",
                                            subtitle: "5問程度")
                        
                        questionCountButton(.normal,
                                            title: "普通",
                                            subtitle: "10問程度")
                        
                        questionCountButton(.many,
                                            title: "多め",
                                            subtitle: "20問程度")
                    }
                }

                
                Button(action: {
                    isShowingDocumentPicker = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("ファイルを追加")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.blue)
                }

                if let url = selectedFileURL {
                    Text("選択されたファイル: \(url.lastPathComponent)")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                }

            }
            .padding(.vertical)
            
            Spacer()
        }
        .background(AppColorToken.background.surface)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
        .sheet(isPresented: $isShowingDocumentPicker) {
            DocumentPicker(selectedFileURL: $selectedFileURL)
        }
    }
    
    private var isTextbookNameValid: Bool {
        !textbookName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    @ViewBuilder
    private func questionCountButton(_ count: QuestionCount,
                                     title: String,
                                     subtitle: String) -> some View {
        let isSelected = (selectedQuestionCount == count)
        
        Button {
            selectedQuestionCount = count
        } label: {
            VStack {
                Text(title)
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
                
                Text(subtitle)
                    .foregroundStyle(.gray)
                    .font(.callout)
            }
        }
    }

}


struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedFileURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // 受け付けるファイルタイプを指定（ここでは何でもOKな例）
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
    CreateTextbookView()
}
