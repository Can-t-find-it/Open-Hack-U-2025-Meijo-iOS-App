import SwiftUI
import UniformTypeIdentifiers
import AppColorTheme

struct CreateTextbookView: View {
    @State private var textbookName: String = ""
    
    @FocusState private var isTextFieldFocused: Bool

    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingDocumentPicker = false
    @State private var selectedFileURL: URL?
    
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
                        Text("おまかせ")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.pink.opacity(0.8))
                            )
                        Text("一問一答")
                            .foregroundStyle(.pink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                            )
                        Text("穴埋め")
                            .foregroundStyle(.pink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                            )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("解答形式")
                        .foregroundStyle(.white)
                    
                    HStack {
                        Text("おまかせ")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.pink.opacity(0.8))
                            )
                        Text("4択問題")
                            .foregroundStyle(.pink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                            )
                        Text("解答入力")
                            .foregroundStyle(.pink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                            )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("問題数")
                        .foregroundStyle(.white)
                    
                    HStack {
                        VStack {
                            Text("おまかせ")
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.pink.opacity(0.8))
                                )
                            
                            Text("自動的に設定")
                                .foregroundStyle(.gray)
                                .font(.callout)
                        }
                        VStack {
                            Text("少なめ")
                                .foregroundStyle(.pink)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                                )
                            Text("5問程度")
                                .foregroundStyle(.gray)
                                .font(.callout)
                        }
                        VStack {
                            Text("普通")
                                .foregroundStyle(.pink)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                                )
                            Text("10問程度")
                                .foregroundStyle(.gray)
                                .font(.callout)
                        }
                        VStack {
                            Text("多め")
                                .foregroundStyle(.pink)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                                )
                            Text("20問程度")
                                .foregroundStyle(.gray)
                                .font(.callout)
                        }
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
