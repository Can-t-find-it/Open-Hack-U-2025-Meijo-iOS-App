struct MyAccountResponse: Codable {
    let id: String
    let name: String
    let stats: UserStats
}

struct UserStats: Codable {
    let textbookCount: Int
    let streakDays: Int
    let friendCount: Int
}

struct StudyLogListResponse: Codable {
    let logs: [StudyLog]
}

struct StudyLog: Codable, Identifiable {
    let id: String
    let userName: String
    let dateTime: String
    let textbookName: String
    let accuracy: Double
}
