import Foundation
import Observation

@MainActor
@Observable
final class FriendsStudyLogListViewViewModel {
    var logs: [FriendStudyLog] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    private let apiClient = APIClient()
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            logs = try await apiClient.fetchFriendsStudyLogs()
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
