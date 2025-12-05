import SwiftUI
import Observation

// MARK: - ViewModel

@MainActor
@Observable
final class FriendListViewViewModel {
    // 共通
    private let apiClient = APIClient()
    
    // 友達一覧
    var friends: [Friend] = []
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
            let response = try await apiClient.fetchFriends()
             self.friends = response
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
            // 🔹 実際の API を叩く
            let results = try await apiClient.searchUsers(keyword: trimmed)
            self.searchResults = results
        } catch {
            print("ユーザー検索失敗: \(error)")
            self.searchErrorMessage = "ユーザー検索に失敗しました。"
            self.searchResults = []
        }
        
        isSearching = false
    }
    
    func sendFriendRequest(to user: FriendSearchResult) async {
        do {
            try await apiClient.addFriend(friendId: user.id)
            
            if let index = searchResults.firstIndex(of: user) {
                searchResults[index] = FriendSearchResult(
                    id: user.id,
                    userName: user.userName,
                    isFriend: true
                )
            }
            
            if !friends.contains(where: { $0.id == user.id }) {
                friends.append(Friend(id: user.id, name: user.userName))
            }
        } catch {
            print("フレンド追加に失敗: \(error)")
        }
    }
}
