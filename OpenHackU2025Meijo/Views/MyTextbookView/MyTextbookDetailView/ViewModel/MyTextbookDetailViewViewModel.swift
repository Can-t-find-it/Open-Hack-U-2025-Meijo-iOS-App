import Foundation
import Observation

@MainActor
@Observable
final class MyTextbookDetailViewViewModel {
    var textbook: TextbookDetail = TextbookDetail(
        id: "",
        name: "",
        type: "",
        questions: [],
        score: [],
        times: 0
    )
    
    var suggestedWords: [String] = []
    
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
            let result = try await apiClient.fetchTextbook(textId: textId)
            print(textId)
            textbook = result
            
            let words = try await apiClient.fetchWordSuggestions(textId: textId)
            suggestedWords = words
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
    
    // 問題集削除
    func deleteTextbook() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiClient.deleteTextbook(textId: textId)
            // ローカル状態もリセットしておく（画面側では pop する想定）
            textbook = TextbookDetail(
                id: "",
                name: "",
                type: "",
                questions: [],
                score: [],
                times: 0
            )
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "問題集の削除に失敗しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isLoading = false
    }
    
    // 単語リストから問題を追加（words は画面側で選んだ単語など）
    func createQuestion(words: [String]) async {
        guard !words.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiClient.createQuestion(textId: textId, words: words)
            
            // 作成後に最新の問題集情報を取得しなおす
            let result = try await apiClient.fetchTextbook(textId: textId)
            textbook = result
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "問題の作成に失敗しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isLoading = false
    }
    
    // 特定の問題を削除
    func deleteQuestion(questionId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiClient.deleteQuestion(questionId: questionId)
            
            // 削除後に問題集を再取得
            let result = try await apiClient.fetchTextbook(textId: textId)
            textbook = result
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "問題の削除に失敗しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isLoading = false
    }
    
    // 特定の問題に問題文を追加
    func createQuestionStatement(questionId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiClient.createQuestionStatement(questionId: questionId)
            
            // 追加後に問題集を再取得
            let result = try await apiClient.fetchTextbook(textId: textId)
            textbook = result
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "問題文の追加に失敗しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isLoading = false
    }
    
    // 特定の問題文を削除
    func deleteQuestionStatement(statementId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await apiClient.deleteQuestionStatement(statementId: statementId)
            
            // 削除後に問題集を再取得
            let result = try await apiClient.fetchTextbook(textId: textId)
            textbook = result
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "問題文の削除に失敗しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        isLoading = false
    }

    
    func countQuestion(of textbook: TextbookDetail) -> Int {
        textbook.questions.count
    }
    
    func calcAverageScore(of scores: [Double]) -> Double {
        guard !scores.isEmpty else { return 0 }
        
        let sum = scores.reduce(0.0, +)
        let average = sum / Double(scores.count)
        
//        return floor(average * 10)
        return average
    }
    
    func calcAverageScorePercent(of scores: [Double]) -> String {
        let value = calcAverageScore(of: scores)
        return String(format: "%.1f %%", value)
    }
    
    func addGeneratedQuestions(from words: [String]) {

    }

}
