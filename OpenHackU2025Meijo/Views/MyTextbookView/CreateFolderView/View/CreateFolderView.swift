import SwiftUI
import AppColorTheme

struct CreateFolderView: View {
    @State private var viewModel = CreateFolderViewViewModel()
    
    @State private var folderName: String = ""
    @FocusState private var isTextFieldFocused: Bool

    @Environment(\.dismiss) private var dismiss

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
                        Task {
                            await viewModel.createFolder(name: folderName)
                            dismiss()
                        }
                    } label: {
                        Text("完了")
                            .foregroundColor(isFolderNameValid ? .blue : .gray) // 色の変化
                    }
                    .disabled(!isFolderNameValid)  // ← 無効化
                }

                Text("フォルダー作成")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()

            VStack {}
                .frame(width: 180, height: 120)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.1),
                            Color.pink.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )

            TextField("フォルダー名を入力", text: $folderName)
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

            Spacer()
        }
        .background(AppColorToken.background.surface)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
    }

    // MARK: - 入力チェック
    private var isFolderNameValid: Bool {
        !folderName.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

#Preview {
    CreateFolderView()
}
