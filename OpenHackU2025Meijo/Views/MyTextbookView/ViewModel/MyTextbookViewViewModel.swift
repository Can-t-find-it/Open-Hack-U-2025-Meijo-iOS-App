import Foundation
import Observation

@Observable
class MyTextbookViewViewModel {
    var myTextbooks: [MyTextbook] = [feMock, takkenMock]
    
    func questionCount(of textbook: MyTextbook) -> Int {
        textbook.questions.count
    }
    // テキスト追加・削除メソッド追加
}
