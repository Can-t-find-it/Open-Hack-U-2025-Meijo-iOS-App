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
