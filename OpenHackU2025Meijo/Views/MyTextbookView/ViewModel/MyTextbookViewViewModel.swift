import Foundation
import Observation

@MainActor
@Observable
final class MyTextbookViewViewModel {
    var folders: [Folder] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var isInitialDelay: Bool = true

    private let apiClient = APIClient()
    
    func start() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 400_000_000)
        isInitialDelay = false
        
        await load()
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await apiClient.fetchFolders()
            folders = result
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
    
    func deleteFolders(ids: Set<Folder.ID>) async {
        guard !ids.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            let idStrings = ids.map { String(describing: $0) }

            try await apiClient.deleteFolders(folderIds: idStrings)

            let result = try await apiClient.fetchFolders()
            folders = result
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "フォルダーの削除に失敗しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }

        isLoading = false
    }
    
    func countTextbook(of folders: Folder) -> Int {
        folders.textbooks.count
    }
}
