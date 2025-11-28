import SwiftUI
import Charts

struct TextbookScoreChart: View {
    let data: [Double]

    var body: some View {
        if data.isEmpty {
            Text("スコアデータがありません")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 150)
                .cardBackground()
        } else {
            chartView
        }
    }

    @ViewBuilder
    private var chartView: some View {
        Chart(data.indices, id: \.self) { index in
            LineMark(
                x: .value("Index", index),
                y: .value("Value", data[index])
            )
            .foregroundStyle(.pink)
            .symbol(Circle())
            .symbolSize(30)
        }
        .frame(height: 200)
        .chartXAxis {
            AxisMarks(values: Array(stride(from: 0, through: max(data.count - 1, 0), by: 2))) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(.pink)
            }
        }
        .chartYAxis {
            AxisMarks(values: Array(stride(from: 0, through: 100, by: 10))) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(.pink)
            }
        }
        .cardBackground()
    }
}


#Preview {
//    MyTextbookDetailView(textbook: feMock)
    MyTextbookDetailView(textName: "基本情報技術者試験", textId: "57385638")
}
