import Foundation
import Observation

@MainActor
@Observable
final class FriendTextbookDetailViewViewModel {
    var textbook: FriendTextbookDetail = FriendTextbookDetail(
        id: "",
        name: "",
        type: "",
        questions: []
    )
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
    
    func addTextbook(
        textbookId: String,
        textbookName: String,
        folderId: String,
        folderName: String
    ) async {

    }
    
    func countQuestion(of textbook: FriendTextbookDetail) -> Int {
        textbook.questions.count
    }
}
