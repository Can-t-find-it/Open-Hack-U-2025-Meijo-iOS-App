import Foundation
import Observation

@MainActor
@Observable
final class AddTextbookViewViewModel {
    var folders: [Folder] = []
    
    // ローディング & エラー
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let apiClient = APIClient()
    
    // 一覧取得
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let folderList = try await apiClient.fetchFolders()
            folders = folderList
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "サーバーエラーが発生しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isLoading = false
    }
}
