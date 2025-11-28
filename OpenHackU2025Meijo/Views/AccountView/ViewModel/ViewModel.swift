import Foundation
import Observation

@MainActor
@Observable
final class AccountViewViewModel {
    var account: MyAccountResponse? = nil
    var isLoading: Bool = false
    var errorMessage: String? = nil

    var userName: String {
        account?.name ?? "username"
    }

    var textbookCount: Int {
        account?.stats.textbookCount ?? 0
    }

    var streakDays: Int {
        account?.stats.streakDays ?? 0
    }

    var friendCount: Int {
        account?.stats.friendCount ?? 0
    }

    private let apiClient = APIClient()

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await apiClient.fetchMyAccount()
            account = result
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

@MainActor
@Observable
final class StudyLogListViewViewModel {
    var logs: [StudyLog] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let apiClient = APIClient()

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await apiClient.fetchMyStudyLogs()
            logs = result
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
