import SwiftUI
import Charts

struct TextbookScoreChart: View {
    let data: [Int]

    var body: some View {
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
            AxisMarks(values: Array(stride(from: 0, through: data.count - 1, by: 2))) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(.pink)   // X軸メモリ色
            }
        }
        .chartYAxis {
            AxisMarks(values: Array(stride(from: 0, through: data.max() ?? 0, by: 2))) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(.pink)   // Y軸メモリ色
            }
        }
        .cardBackground()
    }
}

#Preview {
    MyTextbookDetailView(textbook: feMock)
}
