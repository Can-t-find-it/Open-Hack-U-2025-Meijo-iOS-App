import Foundation

struct APIClient {
    
    private let baseURL: URL = {
        #if targetEnvironment(simulator)
        // Mac の iOS シミュレータからは 127.0.0.1 で Mac ローカルに届く
        return URL(string: "http://127.0.0.1:3658/m1/1133790-1125856-default")!
        #else
        // Mac の LAN IP を使う
        return URL(string: "http://54.95.221.66:8080/api")!
//        return URL(string: "http://s0sh1r0-dev.local:3658/m1/1133790-1125856-default")!
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
    
    // デバイストークン登録
    func registerDeviceToken(_ deviceToken: String) async throws {
        let url = baseURL.appendingPathComponent("/device_token")
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = DeviceTokenRequest(deviceToken: deviceToken)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }


    // サインアップ
    func signUp(name: String, email: String, password: String) async throws -> CertificationResponse {
        let url = baseURL.appendingPathComponent("signup")
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = SignUpRequest(name: name, email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }
        
        do {
            let result = try JSONDecoder().decode(CertificationResponse.self, from: data)
            UserDefaults.standard.set(result.token, forKey: "auth_token")
            return result
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    // ログイン
    func login(email: String, password: String) async throws -> CertificationResponse {
        let url = baseURL.appendingPathComponent("login")
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }
        
        do {
            let result = try JSONDecoder().decode(CertificationResponse.self, from: data)
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
        debugLog(request: request, data: data, response: response)

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
        
        let body = CreateFolderRequest(folderName: name)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }

    // フォルダー削除
    func deleteFolders(folderIds: [String]) async throws {
        let url = baseURL.appendingPathComponent("/folders")
        
        var request = authorizedRequest(url: url, method: "DELETE")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = DeleteFoldersRequest(folderIds: folderIds)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }

    
    // 問題集情報取得
    func fetchTextbook(textId: String) async throws -> TextbookDetail {
        let url = baseURL
            .appendingPathComponent("textbook")
            .appendingPathComponent(textId)
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

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
    
    // 問題集作成
    func createTextbook(name: String, type: String, folderId: String) async throws {
        let url = baseURL.appendingPathComponent("textbooks")

        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = CreateTextbookRequest(name: name, type: type, folderId: folderId)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

        try validate204(response)
    }

    
    // 問題集削除
    func deleteTextbook(textId: String) async throws {
        let url = baseURL
            .appendingPathComponent("textbook")
            .appendingPathComponent(textId)
        
        let request = authorizedRequest(url: url, method: "DELETE")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }
    
    // 問題の追加
    func createQuestion(textId: String, words: [String]) async throws {
        let url = baseURL
            .appendingPathComponent("generate_problem")
            .appendingPathComponent(textId)
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = CreateQuestionRequest(words: words)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }
    
    // 問題を削除
    func deleteQuestion(questionId: String) async throws {
        let url = baseURL
            .appendingPathComponent("question")
            .appendingPathComponent(questionId)
        
        let request = authorizedRequest(url: url, method: "DELETE")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }
    
    // 問題文を追加
    func createQuestionStatement(questionId: String) async throws {
        let url = baseURL
            .appendingPathComponent("generate_statement")
            .appendingPathComponent(questionId)
        
        var request = authorizedRequest(url: url, method: "POST")
        request.httpBody = nil
        
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }
    
    // 問題文を削除
    func deleteQuestionStatement(statementId: String) async throws {
        let url = baseURL
            .appendingPathComponent("questionstatement")
            .appendingPathComponent(statementId)
        
        let request = authorizedRequest(url: url, method: "DELETE")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }
    
    // 友達の問題集一覧取得
    func fetchFriendsTextbooks() async throws -> [FriendTextbooks] {
        let url = baseURL.appendingPathComponent("friend")
            .appendingPathComponent("textbooks")
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

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
        let url = baseURL.appendingPathComponent("friend")
            .appendingPathComponent("textbook")
            .appendingPathComponent(textId)

        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

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
        let url = baseURL.appendingPathComponent("friend")
            .appendingPathComponent("textbooks")

        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = AddFriendTextbookRequest(folderId: folderId, friendTextbookId: friendTextbookId)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

        try validate204(response)
    }
    
    // 友達の学習記録一覧取得
    func fetchFriendsStudyLogs() async throws -> [FriendStudyLog] {
        let url = baseURL.appendingPathComponent("friend")
            .appendingPathComponent("studylog")
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

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
        let url = baseURL.appendingPathComponent("user")
            .appendingPathComponent("status")
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

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
        debugLog(request: request, data: data, response: response)

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
            .appendingPathComponent("textbook")
            .appendingPathComponent(textId)
            .appendingPathComponent("word")
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
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
            .appendingPathComponent("textbook")
            .appendingPathComponent(textbookId)
            .appendingPathComponent("result")
        
        var request = authorizedRequest(url: url, method: "POST")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = CreateMyStudyLogRequest(score: score)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)
        
        try validate204(response)
    }
    
    // フレンド追加
    func addFriend(friendId: String) async throws {
        let url = baseURL
            .appendingPathComponent("friend")
            .appendingPathComponent("change")
            .appendingPathComponent(friendId)
        
        let request = authorizedRequest(url: url, method: "POST")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

        try validate204(response)
    }
    
    // フレンド削除
    func deleteFriend(friendId: String) async throws {
        let url = baseURL
            .appendingPathComponent("friend")
            .appendingPathComponent("change")
            .appendingPathComponent(friendId)
        
        let request = authorizedRequest(url: url, method: "DELETE")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

        try validate204(response)
    }
    
    // フレンド一覧取得
    func fetchFriends() async throws -> [Friend] {
        let url = baseURL
            .appendingPathComponent("friend")
            .appendingPathComponent("change")
        
        let request = authorizedRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

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
    
    private func debugLog(request: URLRequest, data: Data?, response: URLResponse?) {
        print("----- API DEBUG LOG -----")

        // URL
        if let url = request.url {
            print("URL: \(url.absoluteString)")
        }

        // METHOD
        if let method = request.httpMethod {
            print("METHOD: \(method)")
        }

        // HEADER
        if let headers = request.allHTTPHeaderFields {
            print("HEADERS: \(headers)")
        }

        // BODY
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("BODY: \(bodyString)")
        } else {
            print("BODY: none")
        }

        // RESPONSE
        if let http = response as? HTTPURLResponse {
            print("STATUS: \(http.statusCode)")
        }

        // RESPONSE DATA
        if let data,
           let json = String(data: data, encoding: .utf8) {
            print("RESPONSE JSON: \(json)")
        } else {
            print("RESPONSE JSON: none")
        }

        print("--------------------------")
    }

}

extension APIClient {
    func createTextbookFromFile(
        name: String,
        type: String,
        folderId: String,
        fileURL: URL
    ) async throws -> CreateTextbookFromFileResponse {
        let url = baseURL.appendingPathComponent("/upload_pdf")

        var request = authorizedRequest(url: url, method: "POST")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let fileData = try Data(contentsOf: fileURL)
        let filename = fileURL.lastPathComponent
        let mimeType = "application/pdf"

        var body = Data()

        func append(_ string: String) {
            body.append(string.data(using: .utf8)!)
        }

        // name
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"name\"\r\n\r\n")
        append("\(name)\r\n")

        // type
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"type\"\r\n\r\n")
        append("\(type)\r\n")

        // folder_id
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"folder_id\"\r\n\r\n")
        append("\(folderId)\r\n")

        // file
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(fileData)
        append("\r\n")

        // 終端
        append("--\(boundary)--\r\n")

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }

        do {
            let result = try JSONDecoder().decode(CreateTextbookFromFileResponse.self, from: data)
            return result
        } catch {
            throw APIError.decodeError(error)
        }
    }
    
    func createSuggestWordFromFile(
        textbookId: String,
        fileURL: URL
    ) async throws -> [String] {
        let url = baseURL
            .appendingPathComponent("extract_keywords")
            .appendingPathComponent(textbookId)

        var request = authorizedRequest(url: url, method: "POST")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let fileData = try Data(contentsOf: fileURL)
        let filename = fileURL.lastPathComponent
        let mimeType = "application/pdf"

        var body = Data()

        func append(_ string: String) {
            body.append(string.data(using: .utf8)!)
        }

        // file だけ送る
        append("--\(boundary)\r\n")
        append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(fileData)
        append("\r\n")

        // 終端
        append("--\(boundary)--\r\n")

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        debugLog(request: request, data: data, response: response)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode
        }

        do {
            let result = try JSONDecoder().decode(CreateSuggestWordFromFileResponse.self, from: data)
            return result.extractWords          // ← ここで [String] にして返す
        } catch {
            throw APIError.decodeError(error)
        }
    }
}



extension APIClient {
    /// 保存されたトークンで自動ログインを試みる
    /// 成功 = 204 / 失敗 = nil を返す
    func tryAutoLogin() async -> Bool {
        // トークンが保存されていなければ戻す
        guard token != nil else { return false }
        
        // トークンチェック用のAPI（任意のエンドポイントを使ってOK）
        let url = baseURL.appendingPathComponent("/autologin")
        let request = authorizedRequest(url: url, method: "GET")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            debugLog(request: request, data: nil, response: response)

            guard let httpResponse = response as? HTTPURLResponse else {
                return false
            }

            // 204 ならトークン有効
            if httpResponse.statusCode == 204 {
                return true
            } else {
                // トークン無効なので削除
                UserDefaults.standard.removeObject(forKey: "auth_token")
                return false
            }
        } catch {
            return false
        }
    }
}


// エラー種類をざっくり定義
enum APIError: Error {
    case invalidStatusCode
    case decodeError(Error)
}
