import Foundation

struct APIClient {
    
    private let baseURL: URL = {
        #if targetEnvironment(simulator)
        // Mac の iOS シミュレータからは 127.0.0.1 で Mac ローカルに届く
        return URL(string: "http://127.0.0.1:3658/m1/1133790-1125856-default")!
        #else
        // Mac の LAN IP を使う
//        return URL(string: "http://192.168.1.69:3658/m1/1133790-1125856-default")!
        return URL(string: "http://s0sh1r0-dev.local:3658/m1/1133790-1125856-default")!
        #endif
    }()
    
    private var token: String? {
        UserDefaults.standard.string(forKey: "auth_token")
    }
    
    // Authorization Header作成
    private func authorizedRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
    
    // ステータスコード204
    private func validate204(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidStatusCode
        }
        guard httpResponse.statusCode == 204 else {
            throw APIError.invalidStatusCode
        }
    }

    // サインアップ
    func signUp(name: String, email: String, password: String) async throws -> SignUpResponse {
        let url = baseURL.appendingPathComponent("signup")
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = SignUpRequest(name: name, email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }
        
        do {
            let result = try JSONDecoder().decode(SignUpResponse.self, from: data)
            
            UserDefaults.standard.set(result.token, forKey: "auth_token")
            
            return result
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    // ログイン
    func login(email: String, password: String) async throws -> SignUpResponse {
        let url = baseURL.appendingPathComponent("login")
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }
        
        do {
            let result = try JSONDecoder().decode(SignUpResponse.self, from: data)
            
            UserDefaults.standard.set(result.token, forKey: "auth_token")
            
            return result
        } catch {
            throw APIError.decodeError(error)
        }
    }

    // フォルダー一覧取得
    func fetchFolders() async throws -> [Folder] {
        let url = baseURL.appendingPathComponent("/textbooks")
        
        let request = authorizedRequest(url: url, method: "GET")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }

        return try JSONDecoder().decode(FolderResponse.self, from: data).folder
    }
    
    // フォルダー作成
    func createFolder(name: String) async throws {
        let url = baseURL.appendingPathComponent("/folders")
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = CreateFolderRequest(name: name)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate204(response)
    }

    // フォルダー削除
    func deleteFolders(folderIds: [String]) async throws {
        let url = baseURL.appendingPathComponent("/folders")
        
        var request = authorizedRequest(url: url, method: "DELETE")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = DeleteFoldersRequest(folderIds: folderIds)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate204(response)
    }

    
    // 問題集情報取得
    func fetchTextbook(textId: String) async throws -> TextbookDetail {
        let url = baseURL
            .appendingPathComponent("textbook")
            .appendingPathComponent(textId)
        
        let request = authorizedRequest(url: url, method: "GET")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }

        do {
            let result = try JSONDecoder().decode(TextbookDetailResponse.self, from: data)
            return result.textbook
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    // createTextbook
    // 問題集作成
    
    // 問題集削除
    func deleteTextbook(textId: String) async throws {
        let url = baseURL
            .appendingPathComponent("textbook")
            .appendingPathComponent(textId)
        
        let request = authorizedRequest(url: url, method: "DELETE")

        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate204(response)
    }
    
    // 問題の追加
    func createQuestion(textId: String, words: [String]) async throws {
        let url = baseURL
            .appendingPathComponent("question")
            .appendingPathComponent(textId)
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = CreateQuestionRequest(words: words)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate204(response)
    }
    
    // 問題を削除
    func deleteQuestion(questionId: String) async throws {
        let url = baseURL
            .appendingPathComponent("question")
            .appendingPathComponent(questionId)
        
        let request = authorizedRequest(url: url, method: "DELETE")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate204(response)
    }
    
    // 問題文を追加
    func createQuestionStatement(questionId: String) async throws {
        let url = baseURL
            .appendingPathComponent("question-statement")
            .appendingPathComponent(questionId)
        
        var request = authorizedRequest(url: url, method: "POST")
        
        request.httpBody = nil
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate204(response)
    }
    
    // 問題文を削除
    func deleteQuestionStatement(statementId: String) async throws {
        let url = baseURL
            .appendingPathComponent("question-statement")
            .appendingPathComponent(statementId)
        
        let request = authorizedRequest(url: url, method: "DELETE")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate204(response)
    }
    
    // 友達の問題集一覧取得
    func fetchFriendsTextbooks() async throws -> [FriendTextbooks] {
        let url = baseURL.appendingPathComponent("/friend-textbooks")
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }

        do {
            return try JSONDecoder()
                .decode(FriendsTextbooksResponse.self, from: data)
                .friends
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    // 友達の問題集情報取得
    func fetchFriendTextbook(textId: String) async throws -> FriendTextbookDetail {
        let url = baseURL
            .appendingPathComponent("friend-textbook")
            .appendingPathComponent(textId)

        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }

        do {
            let result = try JSONDecoder().decode(FriendTextbookDetailResponse.self, from: data)
            return result.textbook
        } catch {
            throw APIError.decodeError(error)
        }
    }

    
    // 友達の問題集を自分の問題集に追加
    func addFriendTextbookToMyTextbooks(folderId: String, friendTextbookId: String) async throws {
        let url = baseURL.appendingPathComponent("/add-friend-textbook")

        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = AddFriendTextbookRequest(folderId: folderId, friendTextbookId: friendTextbookId)
        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        try validate204(response)
    }
    
    // 友達の学習記録一覧取得
    func fetchFriendsStudyLogs() async throws -> [FriendStudyLog] {
        let url = baseURL.appendingPathComponent("/friends-study-logs")
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }

        do {
            return try JSONDecoder()
                .decode(FriendsStudyLogListResponse.self, from: data)
                .logs
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    // アカウント情報取得
    func fetchMyAccount() async throws -> MyAccountResponse {
        let url = baseURL.appendingPathComponent("/userdata")
        
        let request = authorizedRequest(url: url, method: "GET")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }
        
        do {
            return try JSONDecoder().decode(MyAccountResponse.self, from: data)
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    // 自分の学習ログ取得
    func fetchMyStudyLogs() async throws -> [StudyLog] {
        let url = baseURL.appendingPathComponent("/my-study-logs")

        let request = authorizedRequest(url: url, method: "GET")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }

        do {
            return try JSONDecoder().decode(StudyLogListResponse.self, from: data).logs
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    // AIからの単語提案
    func fetchWordSuggestions(textId: String) async throws -> [String] {
        let url = baseURL
            .appendingPathComponent("wordsugest")
            .appendingPathComponent(textId)
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }
        
        do {
            let result = try JSONDecoder().decode(WordSuggestionsResponse.self, from: data)
            return result.words
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    // 自分の学習ログを記録
    func createMyStudyLog(textbookId: String, score: Double) async throws {
        let url = baseURL
            .appendingPathComponent("my-study-log")
            .appendingPathComponent(textbookId)
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = CreateMyStudyLogRequest(score: score)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        try validate204(response)
    }
    
    // フレンド追加
    func addFriend(friendId: String) async throws {
        let url = baseURL
            .appendingPathComponent("friend")
            .appendingPathComponent(friendId)
        
        let request = authorizedRequest(url: url, method: "POST")

        let (_, response) = try await URLSession.shared.data(for: request)

        try validate204(response)
    }
    
    // フレンド削除
    func deleteFriend(friendId: String) async throws {
        let url = baseURL
            .appendingPathComponent("friend")
            .appendingPathComponent(friendId)
        
        let request = authorizedRequest(url: url, method: "DELETE")

        let (_, response) = try await URLSession.shared.data(for: request)

        try validate204(response)
    }
    
    // フレンド一覧取得
    func fetchFriends() async throws -> [Friend] {
        let url = baseURL.appendingPathComponent("/friends")
        
        let request = authorizedRequest(url: url, method: "GET")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }
        
        do {
            return try JSONDecoder().decode(FriendsListResponse.self, from: data).friends
        } catch {
            throw APIError.decodeError(error)
        }
    }
}

// エラー種類をざっくり定義
enum APIError: Error {
    case invalidStatusCode
    case decodeError(Error)
}
