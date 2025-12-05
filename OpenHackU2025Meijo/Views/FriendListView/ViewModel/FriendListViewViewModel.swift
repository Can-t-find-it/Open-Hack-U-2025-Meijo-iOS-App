import SwiftUI
import Observation

// MARK: - モデル

struct FriendData: Identifiable, Codable, Equatable {
    let id: String
    let userName: String
}

struct FriendSearchResult: Identifiable, Codable, Equatable {
    let id: String
    let userName: String
    let isFriend: Bool
}

// MARK: - ViewModel

@MainActor
@Observable
final class FriendListViewViewModel {
    // 共通
    private let apiClient = APIClient()
    
    // 友達一覧
    var friends: [FriendData] = []
    var isLoadingFriends: Bool = false
    var friendsErrorMessage: String? = nil
    
    // 検索
    var query: String = ""
    var searchResults: [FriendSearchResult] = []
    var isSearching: Bool = false
    var searchErrorMessage: String? = nil
    
    func loadFriends() async {
        isLoadingFriends = true
        friendsErrorMessage = nil
        
        do {
            // TODO: API に合わせて実装してください
            // 例: let response = try await apiClient.fetchFriends()
            // self.friends = response
            
            try await Task.sleep(nanoseconds: 400_000_000)
            self.friends = [
                FriendData(id: "user-001", userName: "りょうが"),
                FriendData(id: "user-002", userName: "そうしろう")
            ]
        } catch {
            friendsErrorMessage = "フレンド一覧の取得に失敗しました。"
        }
        
        isLoadingFriends = false
    }
    
    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            searchErrorMessage = nil
            return
        }
        
        isSearching = true
        searchErrorMessage = nil
        
        do {
            // TODO: API に合わせて実装してください
            // 例: let response = try await apiClient.searchUsers(keyword: trimmed)
            // self.searchResults = response
            
            try await Task.sleep(nanoseconds: 400_000_000)
            self.searchResults = [
                FriendSearchResult(id: "user-001", userName: "りょうが", isFriend: true),
                FriendSearchResult(id: "user-003", userName: "たくみ", isFriend: false)
            ]
        } catch {
            searchErrorMessage = "ユーザー検索に失敗しました。"
        }
        
        isSearching = false
    }
    
    func sendFriendRequest(to user: FriendSearchResult) async {
        // TODO: フレンド申請 API を呼ぶ
        // try await apiClient.sendFriendRequest(userId: user.id)
        
        if let index = searchResults.firstIndex(of: user) {
            searchResults[index] = FriendSearchResult(
                id: user.id,
                userName: user.userName,
                isFriend: true
            )
        }
        
        // すでに friends にいないなら追加してもOK
        if !friends.contains(where: { $0.id == user.id }) {
            friends.append(FriendData(id: user.id, userName: user.userName))
        }
    }
}
