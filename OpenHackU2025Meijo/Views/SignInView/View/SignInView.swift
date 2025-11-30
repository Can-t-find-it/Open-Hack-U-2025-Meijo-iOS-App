import SwiftUI
import AppColorTheme

struct SignInView: View {
    
    private var isLoginEnabled: Bool {
        return !email.isEmpty && !password.isEmpty
    }

    private var isRegisterEnabled: Bool {
        return !userName.isEmpty && !email.isEmpty && !password.isEmpty
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

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                // 上半分：アイコン
                VStack {
                    Spacer()
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                    Spacer()
                }
                .frame(height: proxy.size.height / 2)

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
                            TextField("ユーザーネーム", text: $userName)
                                .textFieldStyle(.roundedBorder)
                        }

                        TextField("メールアドレス", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textFieldStyle(.roundedBorder)

                        SecureField("パスワード", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }

                    // 決定ボタン
                    Button {
                        if mode == .login {
                            // ログイン処理
                        } else {
                            // 新規登録処理
                        }
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
                    .disabled( mode == .login ? !isLoginEnabled : !isRegisterEnabled )

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .frame(height: proxy.size.height / 2)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .fullBackground()   // あなたの背景色拡張
        }
    }

    // タブ用のボタン
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
