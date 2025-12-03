import SwiftUI
import UniformTypeIdentifiers
import AppColorTheme

struct CreateTextbookView: View {
    @State private var textbookName: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingDocumentPicker = false
    @State private var selectedFileURL: URL?
    
    @State private var viewModel = CreateTextbookViewViewModel()
    
    let folderId: String
    
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
    
    var body: some View {
        VStack {
            // ヘッダー
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
                        Task {
                            await viewModel.createTextbook(
                                name: textbookName,
                                type: selectedType,
                                folderId: folderId
                            )
                            dismiss()
                        }
                    } label: {
                        Text("完了")
                            .foregroundColor(isTextbookNameValid ? .blue : .gray)
                    }
                    .disabled(!isTextbookNameValid)
                }
                
                Text("空の問題集を作成")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()
            
            // 問題集名
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
            
            // 設定項目
            VStack(alignment: .leading, spacing: 24) {
                // 問題形式
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

                // 解答方法
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical)

            Spacer()
        }
        .background(AppColorToken.background.surface)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
    }
    
    /// タイトルが空白だけでないか
    private var isTextbookNameValid: Bool {
        !textbookName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    /// 選択された組み合わせから type 文字列を生成
    ///
    /// - 一問一答 × 4択問題 = "4択問題形式"
    /// - 一問一答 × 解答入力 = "入力形式"
    /// - 穴埋め   × 4択問題 = "穴埋めの4択"
    /// - 穴埋め   × 解答入力 = "穴埋め入力"
    private var selectedType: String {
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
}

#Preview {
    CreateTextbookView(folderId: "105")
}
