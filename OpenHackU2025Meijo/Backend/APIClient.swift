import Foundation

struct APIClient {
    
    private var token: String? {
        UserDefaults.standard.string(forKey: "auth_token")
    }
    
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
    
    private func authorizedRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }


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
}

// エラー種類をざっくり定義
enum APIError: Error {
    case invalidStatusCode
    case decodeError(Error)
}
