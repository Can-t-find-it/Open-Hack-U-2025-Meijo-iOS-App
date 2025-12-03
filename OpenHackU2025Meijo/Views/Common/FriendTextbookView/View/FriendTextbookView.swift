import SwiftUI

struct FriendTextbookView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var viewModel: FriendTextbookViewViewModel
    
    @State private var isShowingFolderSelectSheet = false
    @State private var selectedFolderID: Folder.ID? = nil
    
    let userName: String
    let textName: String
    let textId: String
    
    init(userName: String, textName: String, textId: String) {
        self.userName = userName
        self.textName = textName
        self.textId = textId
        _viewModel = State(initialValue: FriendTextbookViewViewModel(textId: textId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                ZStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text(userName)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    Text(textName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.pink).opacity(0.5),
                        Color(.pink).opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.isLoading {
                        ForEach(0..<3) { _ in
                            SkeletonQuestionCard()
                        }
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .padding()
                    } else {
                        ForEach(viewModel.textbook.questions) { question in
                            questionCard(question: question)
                        }
                    }
                }
                .padding()
                
                Button {
                    isShowingFolderSelectSheet = true
                } label: {
                    Text("自分の問題集に追加")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(5)
                        .padding()
                }
            }
            
            Spacer()
        }
        .fullBackground()
        .tabBarHidden(true)
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .bottom)
        .task {
            await viewModel.start()
        }
        .sheet(isPresented: $isShowingFolderSelectSheet) {
            folderSelectSheet
        }
    }
    
    @ViewBuilder
    private func questionCard(question: Question) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // ---- 問題 ----
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
                    ForEach(Array(question.questionStatements.enumerated()), id: \.element.id) { index, statement in
                        
                        HStack {
                            Text("問題文\(index + 1)：\(statement.questionStatement)")
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
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
            
            // ---- 解答 ----
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
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
    }
    
    private var folderSelectSheet: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("どのフォルダーに保存しますか？")
                    .font(.headline)
                    .padding(.top)
                
                if viewModel.isLoading {
                    SkeletonFolderList()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding()
                } else if viewModel.folders.isEmpty {
                    Text("フォルダーがありません")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                } else {
                    List {
                        ForEach(viewModel.folders) { folder in
                            HStack {
                                Text(folder.name)
                                
                                Spacer()
                                
                                if selectedFolderID == folder.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .contentShape(Rectangle()) // 行全体タップ可能に
                            .onTapGesture {
                                selectedFolderID = folder.id
                            }
                        }
                    }
                }
                
                Button {
                    if let id = selectedFolderID,
                       let folder = viewModel.folders.first(where: { $0.id == id }) {
                        
                        Task {
                            await viewModel.addFriendTextbookToMyTextbooks(folderId: folder.id)
                        }
                        
                        isShowingFolderSelectSheet = false
                    }
                } label: {
                    Text("追加")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedFolderID == nil ? Color.gray.opacity(0.4) : Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(selectedFolderID == nil)
                
                Spacer()
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        isShowingFolderSelectSheet = false
                    }
                }
            }
        }
    }
}

struct SkeletonQuestionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 「問題」チップ＋本文エリア
            HStack(alignment: .top, spacing: 8) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.pink.opacity(0.6))
                    .frame(width: 48, height: 22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<2) { _ in
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.45))
                                .frame(height: 12)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.25))
                                .frame(width: 180, height: 10)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 160, height: 10)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // 「解答」行
            HStack(alignment: .top, spacing: 8) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.pink.opacity(0.8), lineWidth: 1)
                    .frame(width: 48, height: 22)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 80, height: 12)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
        .shimmer()
    }
}

struct SkeletonFolderRow: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.4))
                .frame(width: 140, height: 14)
            
            Spacer()
            
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                .frame(width: 20, height: 20)
        }
        .padding(.vertical, 8)
    }
}

struct SkeletonFolderList: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<5) { index in
                SkeletonFolderRow()
                
                if index != 4 {
                    Divider()
                        .background(Color.white.opacity(0.15))
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
        .shimmer()
    }
}

#Preview {
    FriendTextbookView(
        userName: "しまけん",
        textName: "基本情報技術者試験",
        textId: "11"
    )
}
