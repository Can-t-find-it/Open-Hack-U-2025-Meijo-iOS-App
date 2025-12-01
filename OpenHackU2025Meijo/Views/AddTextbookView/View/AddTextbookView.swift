import SwiftUI
import AppColorTheme

struct AddTextbookView: View {
    @State private var textbookName: String = ""
//    @FocusState private var isTextFieldFocused: Bool
    @State private var isShowingCreateFolderSheet = false
    @State private var isShowingDocumentPicker = false
    @State private var selectedFileURL: URL?
    
    @State private var viewModel = AddTextbookViewViewModel()
    
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
    @State private var selectedFolderID: Folder.ID? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                SectionHeaderView(title: "問題集を生成")
                
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
//                    .focused($isTextFieldFocused)

                
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
                            // おまかせ
                            questionCountButton(.auto,
                                                title: "おまかせ",
                                                subtitle: "自動的に設定")
                            
                            // 少なめ
                            questionCountButton(.few,
                                                title: "少なめ",
                                                subtitle: "5問程度")
                            
                            // 普通
                            questionCountButton(.normal,
                                                title: "普通",
                                                subtitle: "10問程度")
                            
                            // 多め
                            questionCountButton(.many,
                                                title: "多め",
                                                subtitle: "20問程度")
                        }
                    }

                    
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
                
                Text("問題集を生成")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(5)
                    .padding()

                Spacer()
            }
            .padding(.horizontal)
            .fullBackground()
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    isTextFieldFocused = true
//                }
//            }
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


#Preview {
    AddTextbookView()
}
