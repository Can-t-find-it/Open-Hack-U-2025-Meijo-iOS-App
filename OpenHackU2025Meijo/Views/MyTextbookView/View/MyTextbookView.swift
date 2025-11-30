import SwiftUI
import AppColorTheme

struct MyTextbookView: View {
    @State private var viewModel = MyTextbookViewViewModel()
    @State private var isShowingCreateFolderSheet = false
    @State private var isEditing = false
    @State private var selectedFolderIDs = Set<Folder.ID>()
    @State private var isShowingDeleteAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {

                        ForEach(viewModel.folders) { folder in
                            let isSelected = selectedFolderIDs.contains(folder.id)

                            Group {
                                if isEditing {
                                    // 編集モード：タップで選択/解除
                                    TextbooksCardView(
                                        title: folder.name,
                                        textbookCount: viewModel.countTextbook(of: folder),
                                        progress: folder.progress
                                    )
                                    .overlay(alignment: .topTrailing) {
                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                            .font(.title3)
                                            .padding(8)
                                    }
                                    .onTapGesture {
                                        if isSelected {
                                            selectedFolderIDs.remove(folder.id)
                                        } else {
                                            selectedFolderIDs.insert(folder.id)
                                        }
                                    }

                                } else {
                                    // 通常モード：タップでフォルダ詳細へ
                                    NavigationLink {
                                        FolderContainView(folder: folder)
                                    } label: {
                                        TextbooksCardView(
                                            title: folder.name,
                                            textbookCount: viewModel.countTextbook(of: folder),
                                            progress: folder.progress
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("問題集一覧")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "完了" : "編集") {
                        withAnimation {
                            isEditing.toggle()
                            if !isEditing {
                                selectedFolderIDs.removeAll()
                            }
                        }
                    }
                    .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        // 編集モード中：削除ボタン
                        Button {
                            // ここではまだ削除せず、アラート表示フラグだけ立てる
                            isShowingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(selectedFolderIDs.isEmpty ? .gray : .red)
                        }
                        .disabled(selectedFolderIDs.isEmpty)
                    } else {
                        // 通常モード中：フォルダ追加ボタン
                        Button {
                            isShowingCreateFolderSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .fullBackground()
            .alert("本当に削除しますか？", isPresented: $isShowingDeleteAlert) {
                Button("削除", role: .destructive) {
                    withAnimation {
                        viewModel.deleteFolders(ids: selectedFolderIDs)
                        selectedFolderIDs.removeAll()
                        isEditing = false
                    }
                }
                Button("キャンセル", role: .cancel) {
                    // 何もしない
                }
            } message: {
                Text("選択中のフォルダーが削除されます。この操作は取り消せません。")
            }
        }
        .task {
            await viewModel.load()
            print("\(viewModel.folders)")
        }
        .sheet(isPresented: $isShowingCreateFolderSheet) {
            CreateFolderView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct FolderContainView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowingCreateTextbookSheet = false
    
    let folder: Folder

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("\(folder.name)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        isShowingCreateTextbookSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(folder.textbooks) { textbook in
                            NavigationLink {
                                MyTextbookDetailView(textName: textbook.name, textId: textbook.id)
                            } label: {
                                TextbookCardView(
                                    title: textbook.name,
                                    questionCount: 5,
                                    questionType: textbook.type
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .fullBackground()
        .navigationBarHidden(true)
        .sheet(isPresented: $isShowingCreateTextbookSheet) {
            CreateTextbookView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    MyTextbookView()
}

#Preview {
    TopView()
}
