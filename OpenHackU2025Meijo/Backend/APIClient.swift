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

        return try JSONDecoder().decode(TextbookDetail.self, from: data)
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
    
    // 友達の学習記録取得
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
            return try JSONDecoder().decode(FriendTextbookDetail.self, from: data)
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

}

// エラー種類をざっくり定義
enum APIError: Error {
    case invalidStatusCode
    case decodeError(Error)
}
