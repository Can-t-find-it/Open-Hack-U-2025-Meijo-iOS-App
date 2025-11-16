import Foundation

// MARK: - Model
struct MyTextbook {
    let id: UUID
    let name: String // 問題集名
    let questionType: QuestionType // 問題形式
    var questions: [Question] // 問題
}

enum QuestionType: String {
    case inputAnswer = "解答入力形式" // 解答入力形式
    case multipleChoice = "4択問題形式" // 4択問題形式
    case fillInTheBlankMultipleChoice = "穴埋め4択問題形式" // 穴埋め4択問題形式
    case fillInTheBlankInputAnswer = "穴埋め解答入力形式" // 穴埋め解答入力形式
    
}

struct Question {
    let id: UUID
    let questionStatements: [QuestionStatement] // 問題文(複数パターン用意)
    let answer: String // 解答
}

struct QuestionStatement {
    let id: UUID
    let questionStatement: String // 問題文
    let choices: [String]? // 4択問題選択肢(4択問題形式ではない場合null)
    let explain: String // 問題解説
}

// MARK: - Mock
let feMock = MyTextbook(
    id: UUID(),
    name: "基本情報技術者試験",
    questionType: .multipleChoice,
    questions: [
        // -----------------------------
        // Q1：情報理論（エントロピー）
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: """
次のうち、シャノンによって提唱された「情報量の指標」として正しいものはどれか？
""",
                    choices: [
                        "A. エントロピー",
                        "B. フーリエ係数",
                        "C. ハミング距離",
                        "D. ナイーブベイズ確率"
                    ],
                    explain: """
エントロピー（Entropy）は「情報量の期待値」を示す指標で、情報理論の基本概念。
ハミング距離は誤り訂正、フーリエ係数は信号処理、ナイーブベイズは機械学習の分類手法である。
"""
                )
            ],
            answer: "A. エントロピー"
        ),
        
        // -----------------------------
        // Q2：ネットワーク（TCP）
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: "TCPで信頼性を保証するために使用される方式はどれか？",
                    choices: [
                        "A. ベストエフォート方式",
                        "B. 再送制御",
                        "C. CSMA/CD",
                        "D. ブロードキャスト制御"
                    ],
                    explain: """
TCPは信頼性を保証するために「再送制御」「順序制御」「輻輳制御」などを行う。
CSMA/CDはイーサネットのアクセス方式、ベストエフォートはUDPなどの特徴。
"""
                )
            ],
            answer: "B. 再送制御"
        ),
        
        // -----------------------------
        // Q3：アルゴリズム（計算量）
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: "バブルソートの平均時間計算量として正しいものはどれか？",
                    choices: [
                        "A. O(n)",
                        "B. O(n log n)",
                        "C. O(n²)",
                        "D. O(2ⁿ)"
                    ],
                    explain: """
バブルソートの計算量は最悪・平均ともに O(n²)。データが逆順に近いと比較回数が最大になる。
"""
                )
            ],
            answer: "C. O(n²)"
        ),
        
        // -----------------------------
        // Q4：データベース（正規化）
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: """
正規化に関する説明として正しいものはどれか？
""",
                    choices: [
                        "A. 第1正規形は部分関数従属を排除する",
                        "B. 第2正規形は繰り返し項目を排除する",
                        "C. 第3正規形は推移的関数従属を排除する",
                        "D. BCNFは多値従属を排除する"
                    ],
                    explain: """
第3正規形は「推移的関数従属を排除する」ことでデータの一貫性を高める。
第1正規形：繰り返し項目を排除  
第2正規形：部分関数従属の排除  
BCNF：関数従属の左辺が候補キーであること
"""
                )
            ],
            answer: "C. 第3正規形は推移的関数従属を排除する"
        ),
        
        // -----------------------------
        // Q5：セキュリティ（攻撃手法）
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: """
攻撃者が多数の端末を乗っ取り、同時にアクセスさせてサービスを停止させる攻撃はどれか？
""",
                    choices: [
                        "A. SQLインジェクション",
                        "B. クロスサイトスクリプティング",
                        "C. DDoS攻撃",
                        "D. フィッシング"
                    ],
                    explain: """
DDoS攻撃（Distributed Denial of Service）は複数の端末から大量アクセスさせ、サービスを不能にする攻撃。
"""
                )
            ],
            answer: "C. DDoS攻撃"
        )
    ]
)

let takkenMock = MyTextbook(
    id: UUID(),
    name: "宅建",
    questionType: .multipleChoice,
    questions: [
        // -----------------------------
        // Q1：宅建業の免許
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: """
宅地建物取引業法上、「宅建業の免許」が必要となる行為の組合せとして正しいものはどれか。
""",
                    choices: [
                        "A. 自己所有の土地を、自ら居住用として1回だけ売却する",
                        "B. アパートの一室を、友人のために無償で紹介する行為を継続して行う",
                        "C. 他人の土地の売買を、反復継続して報酬を得て仲介する",
                        "D. 親族間で一度だけ、無償で土地の売買契約書作成を手伝う"
                    ],
                    explain: """
宅建業とは「他人のために」「宅地・建物の売買・交換・貸借」を
「反復継続して」「報酬を得る目的で」行う事業をいう。
この定義に当てはまるのは、他人の土地の売買を、反復継続して報酬を得て仲介する C が正しい。
"""
                )
            ],
            answer: "C. 他人の土地の売買を、反復継続して報酬を得て仲介する"
        ),

        // -----------------------------
        // Q2：重要事項説明
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: "宅地建物取引士による重要事項説明に関する記述として、正しいものはどれか。",
                    choices: [
                        "A. 宅地建物取引士であれば、取引士証を携帯していなくても重要事項の説明はできる",
                        "B. 重要事項説明書は、書面を交付せず口頭説明のみで足りる",
                        "C. 重要事項説明は、必ず宅地建物取引士が書面を交付し記名押印したうえで行う必要がある",
                        "D. 重要事項説明は、売買契約の締結後に行ってもよい"
                    ],
                    explain: """
重要事項説明は、宅地建物取引士が「取引士証を提示」し、
記名押印した「書面を交付」して、契約締結前に説明しなければならない。
したがって、C が正しい。
"""
                )
            ],
            answer: "C. 重要事項説明は、必ず宅地建物取引士が書面を交付し記名押印したうえで行う必要がある"
        ),

        // -----------------------------
        // Q3：手付解除（売買契約）
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: """
宅地の売買契約において「解約手付」が授受された場合の説明として、民法および一般的な実務慣行に照らして正しいものはどれか。
""",
                    choices: [
                        "A. 買主は、手付金を放棄すれば、引渡し後であってもいつでも契約を解除できる",
                        "B. 売主は、受け取った手付金の倍額を返還することで、契約を解除できる場合がある",
                        "C. 手付が授受された後は、当事者双方ともに一方的に契約を解除することはできない",
                        "D. 手付はあくまで前払金であり、解約権とは関係がない"
                    ],
                    explain: """
解約手付が授受された場合、買主は手付を放棄し、
売主は手付の倍額を償還することで契約を解除できる（ただし履行に着手する前まで）。
この説明に該当するのは B。
"""
                )
            ],
            answer: "B. 売主は、受け取った手付金の倍額を返還することで、契約を解除できる場合がある"
        ),

        // -----------------------------
        // Q4：契約不適合責任（改正民法）
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: """
改正民法における「契約不適合責任」に関する説明として、最も適切なものはどれか。
""",
                    choices: [
                        "A. 売主の責任は、買主が目的物を引き渡された時点で直ちに消滅する",
                        "B. 契約内容に適合しない場合、買主は追完請求・代金減額請求・損害賠償請求などを行うことができる",
                        "C. 契約不適合があっても、買主は解除以外の請求は一切できない",
                        "D. 契約不適合責任は、物権的請求権の一種である"
                    ],
                    explain: """
改正民法では「契約不適合責任」として、
契約内容に適合しない場合に、買主は追完請求・代金減額請求・損害賠償請求・解除などを行うことができる。
したがって B が正しい。
"""
                )
            ],
            answer: "B. 契約内容に適合しない場合、買主は追完請求・代金減額請求・損害賠償請求などを行うことができる"
        ),

        // -----------------------------
        // Q5：用途地域（都市計画法）
        // -----------------------------
        Question(
            id: UUID(),
            questionStatements: [
                QuestionStatement(
                    id: UUID(),
                    questionStatement: """
用途地域に関する次の記述のうち、第一種低層住居専用地域の特徴として最も適切なものはどれか。
""",
                    choices: [
                        "A. 大規模な工場や倉庫を自由に建築できる地域である",
                        "B. 主として商業施設の立地を図る地域であり、パチンコ店などの建築が認められる",
                        "C. 低層住宅の良好な住環境を保護するための地域であり、建ぺい率・容積率などが比較的厳しく制限される",
                        "D. 住居専用地域ではないため、住宅の建築は原則として認められない"
                    ],
                    explain: """
第一種低層住居専用地域は、低層住宅の良好な住環境の保護を目的とする用途地域であり、
建ぺい率・容積率・高さ制限などが比較的厳しく設定されている。
したがって C が正しい。
"""
                )
            ],
            answer: "C. 低層住宅の良好な住環境を保護するための地域であり、建ぺい率・容積率などが比較的厳しく制限される"
        )
    ]
)
