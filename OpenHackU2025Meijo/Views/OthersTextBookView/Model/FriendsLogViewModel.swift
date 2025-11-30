struct FriendsStudyLogListResponse: Codable {
    let logs: [FriendStudyLog]
}

struct FriendStudyLog: Codable, Identifiable {
    let logId: String
    let friendId: String
    let friendName: String
    let dateTime: String
    let textbookName: String
    let textbookId: String
    let accuracy: Double        // 0.0 ~ 100.0
    let todayProgress: Int      // 0 ~ 100 (%)
    let likeCount: Int
    let commentCount: Int
    
    var id: String { logId }
}
