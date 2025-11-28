//import SwiftUI
//
//
//
//
//
//struct Data {
//     private struct TextbooksFolder {
//        let name: String
//        let textbooks: [Textbook]
//    }
//
//    private struct Textbook {
//        let id: UUID
//        let name: String // 問題集名
//        let questionType: QuestionType // 問題形式
//        var questions: [Question] // 問題
//        // 学習回数
//    }
//
//    private struct Question {
//        let id: UUID
//        let questionStatements: [QuestionStatement] // 問題文(複数パターン用意)
//        let answer: String // 解答
//    }
//    
//    private struct QuestionStatement {
//        let id: UUID
//        let questionStatement: String // 問題文
//        let choices: [String]? // 4択問題選択肢(4択問題形式ではない場合null)
//        let explain: String // 問題解説
//    }
//    
//    private enum QuestionType: String {
//        case inputAnswer = "解答入力形式" // 解答入力形式
//        case multipleChoice = "4択問題形式" // 4択問題形式
//        case fillInTheBlankMultipleChoice = "穴埋め4択問題形式" // 穴埋め4択問題形式
//        case fillInTheBlankInputAnswer = "穴埋め解答入力形式" // 穴埋め解答入力形式
//        
//    }
//}
