import SwiftUI
import AppColorTheme

struct SignInView: View {
    @Environment(\.dismiss) private var dismiss
    
    private var isLoginEnabled: Bool {
        !email.isEmpty && !password.isEmpty
    }

    private var isRegisterEnabled: Bool {
        !userName.isEmpty && !email.isEmpty && !password.isEmpty
    }

    enum Mode {
        case login
        case register
    }

    @State private var mode: Mode = .login

    // 入力値
    @State private var userName = ""
    @State private var email = ""
    @State private var password = ""

    // フォーカス状態（メールアドレス用）
    @FocusState private var isEmailFocused: Bool

    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                // 上半分：アイコン
                VStack {
                    Spacer()
                    Image("icon1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    Spacer()
                }
                .frame(maxHeight: .infinity)

                // 下半分：白いフォーム
                VStack(spacing: 24) {

                    // ログイン / 登録 タブ
                    HStack {
                        modeButton(.login, title: "ログイン")
                        modeButton(.register, title: "登録")
                    }

                    // フォーム
                    VStack(spacing: 16) {
                        if mode == .register {
                            customTextField("ユーザーネーム", text: $userName)
                        }

                        emailTextField()   // ← 自動フォーカス付きメール欄
                        customSecureField("パスワード", text: $password)
                    }

                    // 決定ボタン
                    Button {
                        if mode == .login {
                            // ログイン処理
                        } else {
                            // 新規登録処理
                        }
                        dismiss()
                    } label: {
                        Text(mode == .login ? "ログイン" : "登録する")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                (mode == .login ? isLoginEnabled : isRegisterEnabled)
                                ? Color.blue
                                : Color.gray
                            )
                            .cornerRadius(8)
                    }
                    .disabled(mode == .login ? !isLoginEnabled : !isRegisterEnabled)

                    Spacer(minLength: 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .ignoresSafeArea(.all, edges: .bottom)
                )
            }
            .fullBackground()
        }
        .task {
            // 0.4秒遅延してキーボード表示（メール欄にフォーカス）
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                isEmailFocused = true
            }
        }
    }

    // MARK: - 各種フィールド

    /// 共通スタイルの TextField（ユーザーネーム用など）
    private func customTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField("", text: text)
            .foregroundColor(.black)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .overlay(alignment: .leading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .padding(.leading, 16)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
    }

    /// メールアドレス用（フォーカス付き）
    private func emailTextField() -> some View {
        TextField("", text: $email)
            .foregroundColor(.black)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .overlay(alignment: .leading) {
                if email.isEmpty {
                    Text("メールアドレス")
                        .foregroundColor(Color.gray.opacity(0.3))
                        .padding(.leading, 16)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .keyboardType(.emailAddress)
            .focused($isEmailFocused)   // ★ フォーカスをここに当てる
    }

    private func customSecureField(_ placeholder: String, text: Binding<String>) -> some View {
        SecureField("", text: text)
            .foregroundColor(.black)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .overlay(alignment: .leading) {
                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.gray.opacity(0.3))
                        .padding(.leading, 16)
                }
            }
    }

    // MARK: - タブ用のボタン

    private func modeButton(_ target: Mode, title: String) -> some View {
        Button {
            mode = target
        } label: {
            VStack(spacing: 4) {
                Text(title)
                    .foregroundColor(mode == target ? .blue : .gray)
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(mode == target ? .blue : .clear)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SignInView()
}
