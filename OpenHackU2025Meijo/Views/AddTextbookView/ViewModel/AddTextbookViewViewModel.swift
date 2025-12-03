import Foundation
import Observation

@MainActor
@Observable
final class AddTextbookViewViewModel {
    var folders: [Folder] = []
    
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // 生成結果
    var generatedTextbook: GeneratedTextbook? = nil   // 👈 追加

    private let apiClient = APIClient()
    
    // 一覧取得
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let folderList = try await apiClient.fetchFolders()
            folders = folderList
        } catch {
            handleError(error, defaultMessage: "フォルダー一覧の取得に失敗しました。")
        }
        
        isLoading = false
    }
    
    // PDF付き問題集生成
    func createTextbook(
        name: String,
        type: String,
        folderId: String,
        fileURL: URL
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiClient.createTextbookFromFile(
                name: name,
                type: type,
                folderId: folderId,
                fileURL: fileURL
            )
            // 🔽 ここで丸ごと保持
            generatedTextbook = response.textbook

            // 必要ならここでログ
            print("作成されたTextbook ID: \(response.textbook.id)")
            print("問題数: \(response.textbook.questions.count)")
        } catch {
            handleError(error, defaultMessage: "問題集の生成に失敗しました。")
        }
        
        isLoading = false
    }
    
    private func handleError(_ error: Error, defaultMessage: String) {
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidStatusCode:
                errorMessage = defaultMessage
            case .decodeError:
                errorMessage = "データの読み取りに失敗しました。"
            }
        } else {
            errorMessage = "通信エラーが発生しました。"
        }
    }
}

