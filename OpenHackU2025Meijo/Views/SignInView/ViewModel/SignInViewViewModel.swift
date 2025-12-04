import Foundation
import Observation

@MainActor
@Observable
final class SignInViewViewModel {
    // ローディング・エラー表示用
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private let apiClient = APIClient()
    
    /// ログイン
    @discardableResult
    func login(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            // 戻り値は使わなくてもOK（APIClient 内で token を保存している）
            _ = try await apiClient.login(email: email, password: password)
            isLoading = false
            return true
        } catch let apiError as APIError {
            switch apiError {
            case .invalidStatusCode:
                errorMessage = "メールアドレスまたはパスワードが間違っています。"
            case .decodeError:
                errorMessage = "サーバーからのデータの読み取りに失敗しました。"
            }
            isLoading = false
            return false
        } catch {
            errorMessage = "通信エラーが発生しました。"
            isLoading = false
            return false
        }
    }
    
    /// サインアップ
    @discardableResult
    func signUp(name: String, email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await apiClient.signUp(name: name, email: email, password: password)
            isLoading = false
            return true
        } catch let apiError as APIError {
            switch apiError {
            case .invalidStatusCode:
                errorMessage = "ユーザー登録に失敗しました。入力内容を確認してください。"
            case .decodeError:
                errorMessage = "サーバーからのデータの読み取りに失敗しました。"
            }
            isLoading = false
            return false
        } catch {
            errorMessage = "通信エラーが発生しました。"
            isLoading = false
            return false
        }
    }
}
