import Foundation
import Observation

@MainActor
@Observable
final class AddTextbookViewViewModel {
    var folders: [Folder] = []
    
    var isLoading: Bool = false
    var errorMessage: String? = nil

    // 生成結果
    var generatedTextbook: GeneratedTextbook? = nil

    // 🔵 追加：問題集生成中フラグ & 進捗
    var isGeneratingTextbook: Bool = false
    var generateProgress: Double = 0.0

    private let apiClient = APIClient()
    
    // 一覧取得
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let folderList = try await apiClient.fetchFolders()
            folders = folderList
        } catch {
            handleError(error, defaultMessage: "フォルダー一覧の取得に失敗しました。")
        }
        
        isLoading = false
    }
    
    // PDF付き問題集生成
    func createTextbook(
        name: String,
        type: String,
        folderId: String,
        fileURL: URL
    ) async {
        // 🔵 isLoading ではなく isGeneratingTextbook で制御
        isGeneratingTextbook = true
        generateProgress = 0.0
        errorMessage = nil
        
        // 疑似プログレスタスク（DetailView と同じパターン）
        let progressTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 600_000_000)
                await MainActor.run {
                    if self.generateProgress < 0.9 {
                        self.generateProgress += 0.02
                    }
                }
            }
        }
        
        do {
            let response = try await apiClient.createTextbookFromFile(
                name: name,
                type: type,
                folderId: folderId,
                fileURL: fileURL
            )
            
            await MainActor.run {
                // 丸ごと保持
                self.generatedTextbook = response.textbook
                // 成功したら 1.0 まで
                self.generateProgress = 1.0
            }
            
            print("作成されたTextbook ID: \(response.textbook.id)")
            print("問題数: \(response.textbook.questions.count)")
            
            // 1.0 を少し見せてから終了
            try? await Task.sleep(nanoseconds: 300_000_000)
            
        } catch {
            handleError(error, defaultMessage: "問題集の生成に失敗しました。")
        }
        
        // 疑似プログレスタスクを停止
        progressTask.cancel()
        
        isGeneratingTextbook = false
        generateProgress = 0.0
    }
    
    private func handleError(_ error: Error, defaultMessage: String) {
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidStatusCode:
                errorMessage = defaultMessage
            case .decodeError:
                errorMessage = "データの読み取りに失敗しました。"
            }
        } else {
            errorMessage = "通信エラーが発生しました。"
        }
    }
}
