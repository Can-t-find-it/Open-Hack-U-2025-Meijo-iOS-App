import Foundation
import Observation

@MainActor
@Observable
final class AccountViewViewModel {
    var account: MyAccountResponse? = nil
    var logs: [StudyLog] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var isInitialDelay: Bool = true

    var userName: String {
        account?.name ?? "username"
    }

    var textbookCount: Int {
        account?.status.textbookCount ?? 0
    }

    var streakDays: Int {
        account?.status.streakDays ?? 0
    }

    var friendCount: Int {
        account?.status.friendCount ?? 0
    }

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
            let accountResult = try await apiClient.fetchMyAccount()
            account = accountResult
            
            let logsResult = try await apiClient.fetchMyStudyLogs()
            logs = logsResult
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "サーバーエラーが発生しました。"
                case .decodeError(_):
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }

        isLoading = false
    }
}
