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

struct SkeletonScoreChartView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // タイトルっぽい棒
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.35))
                .frame(width: 120, height: 16)

            // グラフ領域
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.15))
                .frame(height: 180)
                .overlay {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(0..<7) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.25))
                                .frame(width: 14, height: CGFloat.random(in: 40...140))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
        )
        .shimmer() // ← さっき作った shimmer() をそのまま使用
    }
}


#Preview {
//    MyTextbookDetailView(textbook: feMock)
    MyTextbookDetailView(textName: "基本情報技術者試験", textId: "57385638")
}
