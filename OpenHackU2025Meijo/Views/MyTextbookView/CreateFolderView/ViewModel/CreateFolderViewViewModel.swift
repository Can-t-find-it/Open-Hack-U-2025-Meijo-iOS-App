import SwiftUI
import Observation

@MainActor
@Observable
final class CreateFolderViewViewModel {
    var folders: [Folder] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let apiClient = APIClient()
    
    func createFolder(name: String) async {
        guard !name.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            try await apiClient.createFolder(name: name)

            let result = try await apiClient.fetchFolders()
            folders = result
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "フォルダーの作成に失敗しました。"
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
