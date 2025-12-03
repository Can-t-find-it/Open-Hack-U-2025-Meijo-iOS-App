import SwiftUI
import Observation

@MainActor
@Observable
final class CreateTextbookViewViewModel {
    var folders: [Folder] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let apiClient = APIClient()
    
    func createTextbook(name: String, type: String, folderId: String) async {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !folderId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            try await apiClient.createTextbook(
                name: name,
                type: type,
                folderId: folderId
            )

            let result = try await apiClient.fetchFolders()
            folders = result
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "問題集の作成に失敗しました。"
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

