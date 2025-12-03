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
    var pdfWords: [String] = []
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    var isInitialDelay: Bool = true
    
    var isExtractingFromPDF: Bool = false
    var extractProgress: Double = 0.0
    
    var isGeneratingQuestions: Bool = false
    var generateProgress: Double = 0.0
    
    var addingStatementQuestionId: String? = nil
    var addStatementProgress: Double = 0.0

    private let apiClient = APIClient()
    
    let textId: String
    
    init(textId: String) {
        self.textId = textId
    }
    
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
            let result = try await apiClient.fetchTextbook(textId: textId)
            print(textId)
            textbook = result
            
            let aiWords = try await apiClient.fetchWordSuggestions(textId: textId)
            suggestedWords = aiWords
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
    
    func fetchExtractWords(from fileURL: URL) async {
        errorMessage = nil

        isExtractingFromPDF = true
        extractProgress = 0.0
        
        // プログレスをじわじわ増やすタスク
        let progressTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 80_000_000) // 0.08 秒間隔
                await MainActor.run {
                    // 通信が終わるまでは 0.9 までしか行かないようにする
                    if self.extractProgress < 0.9 {
                        self.extractProgress += 0.02
                    }
                }
            }
        }

        do {
            let extractWords = try await apiClient.createSuggestWordFromFile(
                textbookId: textId,
                fileURL: fileURL
            )
            
            await MainActor.run {
                self.pdfWords = extractWords
                // 通信成功 → 1.0 まで一気に進める
                self.extractProgress = 1.0
            }
            
            // 1.0 を少しだけ見せてから終了
            try? await Task.sleep(nanoseconds: 300_000_000)
            
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .invalidStatusCode:
                    errorMessage = "PDF から単語抽出に失敗しました。"
                case .decodeError:
                    errorMessage = "データの読み取りに失敗しました。"
                }
            } else {
                errorMessage = "通信エラーが発生しました。"
            }
        }
        
        // プログレスタスクを止める
        progressTask.cancel()
        
        isExtractingFromPDF = false
        extractProgress = 0.0
        isLoading = false
    }


    // 単語リストから問題を追加（words は画面側で選んだ単語など）
    func createQuestion(words: [String]) async {
        guard !words.isEmpty else { return }

        isGeneratingQuestions = true
        generateProgress = 0.0
        errorMessage = nil
        
        // 擬似プログレスをじわじわ増やすタスク
        let progressTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 80_000_000) // 0.08秒ごと
                await MainActor.run {
                    if self.generateProgress < 0.9 {
                        self.generateProgress += 0.02
                    }
                }
            }
        }

        do {
            // 問題生成 API
            try await apiClient.createQuestion(textId: textId, words: words)
            
            // 作成後に最新状態を取得
            let result = try await apiClient.fetchTextbook(textId: textId)
            
            await MainActor.run {
                self.textbook = result
                self.generateProgress = 1.0    // 最後に 1.0 まで進める
            }
            
            // 1.0 の状態を少し見せてから終了
            try? await Task.sleep(nanoseconds: 300_000_000)
            
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

        // 擬似プログレスタスク停止
        progressTask.cancel()
        
        isGeneratingQuestions = false
        generateProgress = 0.0
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
        errorMessage = nil
        
        // どの問題に対して追加中かを記録
        addingStatementQuestionId = questionId
        addStatementProgress = 0.0
        
        // 疑似プログレスをじわじわ増やすタスク
        let progressTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 80_000_000) // 0.08秒ごと
                await MainActor.run {
                    if self.addStatementProgress < 0.9 {
                        self.addStatementProgress += 0.02
                    }
                }
            }
        }

        do {
            // API で問題文追加
            try await apiClient.createQuestionStatement(questionId: questionId)
            
            // 追加後に最新の問題集を取得
            let result = try await apiClient.fetchTextbook(textId: textId)
            
            await MainActor.run {
                self.textbook = result
                self.addStatementProgress = 1.0   // 最後に 1.0 まで進める
            }
            
            // 1.0 の状態を少しだけ見せる
            try? await Task.sleep(nanoseconds: 300_000_000)
            
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
        
        // 疑似プログレスタスク停止
        progressTask.cancel()
        
        addingStatementQuestionId = nil
        addStatementProgress = 0.0
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
