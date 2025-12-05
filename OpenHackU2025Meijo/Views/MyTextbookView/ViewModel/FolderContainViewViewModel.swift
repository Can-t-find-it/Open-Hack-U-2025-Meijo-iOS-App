import SwiftUI
import Observation

@MainActor
@Observable
final class FolderContainViewViewModel {
    var folder: Folder
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let apiClient = APIClient()

    init(folder: Folder) {
        self.folder = folder
    }

    func reloadFolder() async {
        isLoading = true
        errorMessage = nil

        do {
            // ここは API の仕様に合わせて調整してください
            // 例: fetchFolders から該当フォルダだけ探すパターン
            let folders = try await apiClient.fetchFolders()
            if let updated = folders.first(where: { $0.id == folder.id }) {
                folder = updated
            } else {
                errorMessage = "フォルダーが見つかりませんでした。"
            }
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "フォルダーの取得に失敗しました。"
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
