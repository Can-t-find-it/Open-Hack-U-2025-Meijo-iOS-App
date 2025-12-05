import Foundation
import Observation

@MainActor
@Observable
final class QuizViewViewModel {
    private let apiClient = APIClient()
    
    var isSaving: Bool = false
    var errorMessage: String? = nil
    
    /// 学習ログをサーバーに送信
    func createMyStudyLog(textbookId: String, score: Double) async {
        isSaving = true
        errorMessage = nil
        
        do {
            try await apiClient.createMyStudyLog(textbookId: textbookId, score: score)
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "学習結果の保存に失敗しました。"
                case .decodeError:
                    errorMessage = "サーバーからのデータ読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isSaving = false
    }
    
    func addMyStudyLog(textbookId: String, score: Double) async {
        isSaving = true
        errorMessage = nil
        
        do {
            try await apiClient.addMyStudyLog(textbookId: textbookId, score: score)
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "学習結果の保存に失敗しました。"
                case .decodeError:
                    errorMessage = "サーバーからのデータ読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isSaving = false
    }
}
