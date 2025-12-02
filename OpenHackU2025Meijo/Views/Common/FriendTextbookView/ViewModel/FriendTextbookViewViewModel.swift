import Foundation
import Observation

@MainActor
@Observable
final class FriendTextbookViewViewModel {
    var textbook: FriendTextbookDetail = FriendTextbookDetail(
        id: "",
        name: "",
        type: "",
        questions: []
    )
    var folders: [Folder] = []
    
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let apiClient = APIClient()
    
    let textId: String
    
    init(textId: String) {
        self.textId = textId
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await apiClient.fetchFriendTextbook(textId: textId)
            textbook = result
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
    
    func addFriendTextbookToMyTextbooks(folderId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiClient.addFriendTextbookToMyTextbooks(
                folderId: folderId,
                friendTextbookId: textId
            )
            
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "問題集の追加に失敗しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isLoading = false
    }
    
    func countQuestion(of textbook: FriendTextbookDetail) -> Int {
        textbook.questions.count
    }
}
