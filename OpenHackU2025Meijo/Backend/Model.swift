import Foundation

struct FolderResponse: Codable {
    let folder: [Folder]
}

struct Folder: Identifiable, Codable {
    let id: String
    let name: String
    let progress: Int
    let textbooks: [Textbook]
}

struct Textbook: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
}

struct CreateFolderRequest: Codable {
    let name: String
}

struct DeleteFoldersRequest: Codable {
    let folderIds: [String]
}

struct TextbookDetailResponse: Codable {
    let textbook: TextbookDetail
}

struct TextbookDetail: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let questions: [Question]
    let score: [Double]
    let times: Int
}

struct Question: Identifiable, Codable {
    let id: String
    let questionStatements: [QuestionStatement]
    let answer: String
}

struct QuestionStatement: Identifiable, Codable {
    let id: String
    let questionStatement: String // 問題文
    let choices: [String]? // 4択問題選択肢(4択問題形式ではない場合null)
    let explain: String // 問題解説
}

enum QuestionType: String {
    case inputAnswer = "解答入力形式" // 解答入力形式
    case multipleChoice = "4択問題形式" // 4択問題形式
    case fillInTheBlankMultipleChoice = "穴埋め4択問題形式" // 穴埋め4択問題形式
    case fillInTheBlankInputAnswer = "穴埋め解答入力形式" // 穴埋め解答入力形式
    
}

struct MyTextbook {
    let id: UUID
    let name: String // 問題集名
    let questionType: QuestionType // 問題形式
    var questions: [Question] // 問題
    // 学習回数
}

struct CreateQuestionRequest: Codable {
    let words: [String]
}

struct FriendsTextbooksResponse: Codable {
    let friends: [FriendTextbooks]
}

struct FriendTextbooks: Codable, Identifiable {
    let friendId: String
    let userName: String
    let textbooks: [FriendTextbook]
    
    var id: String { friendId }
}

struct FriendTextbook: Codable, Identifiable {
    let textbookId: String
    let name: String
    let questionCount: Int
    
    var id: String { textbookId }
}

struct FriendTextbookDetailResponse: Codable {
    let textbook: FriendTextbookDetail
}

struct FriendTextbookDetail: Codable, Identifiable {
    let id: String
    let name: String
    let type: String
    let questions: [Question]
}

struct AddFriendTextbookRequest: Codable {
    let folderId: String
    let friendTextbookId: String
}

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
    
    var id: String { logId }
}

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

struct WordSuggestionsResponse: Codable {
    let words: [String]
}

struct CreateMyStudyLogRequest: Codable {
    let score: Double
}

struct FriendsListResponse: Codable {
    let friends: [Friend]
}

struct Friend: Codable, Identifiable {
    let id: Int
    let name: String
}
