import SwiftUI
import AppColorTheme

struct MyTextbookView: View {
    @State private var viewModel = MyTextbookViewViewModel()
    @State private var isShowingCreateFolderSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(viewModel.folders) { folder in
                            NavigationLink {
                                FolderContainView(folder: folder)
                            } label: {
                                TextbooksCardView(title: folder.name, textbookCount: viewModel.countTextbook(of: folder), progress: folder.progress)
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
                    Text("編集")
                        .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingCreateFolderSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                    }
                }
            }
            .fullBackground()
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
