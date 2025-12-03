import Foundation
import Observation

@MainActor
@Observable
final class FriendsTextbooksViewViewModel {
    // 友達ごとの問題集一覧
    var friends: [FriendTextbooks] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    var isInitialDelay: Bool = true
    
    var allTextbookNames: [String] {
        Array(
            Set(
                friends.flatMap { friend in
                    friend.textbooks.map { $0.name }
                }
            )
        )
    }
    
    /// 全ての友達の名前（重複なし）
    var allUserNames: [String] {
        friends.map { $0.userName }
    }

    private let apiClient = APIClient()
    
    func start() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 400_000_000)
        isInitialDelay = false
        
        await load()
    }
    
    // 一覧取得
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await apiClient.fetchFriendsTextbooks()
            friends = result
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
    
    // 便利メソッド: 友達1人あたりの問題集数
    func textbookCount(of friend: FriendTextbooks) -> Int {
        friend.textbooks.count
    }
    
    // 便利メソッド: 友達1人あたりの総問題数
    func totalQuestionCount(of friend: FriendTextbooks) -> Int {
        friend.textbooks.reduce(0) { $0 + $1.questionCount }
    }
}
