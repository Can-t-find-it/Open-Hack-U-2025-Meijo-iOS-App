import SwiftUI
import Charts

struct MyTextbookDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let textbook: MyTextbook
    @State private var viewModel = MyTextbookViewViewModel()
    
    let data: [Int] = [5, 7, 3, 8, 2, 10, 8, 8, 9, 1, 5]
    
    var body: some View {
        VStack {
            TextbookDetailViewHeader(
                title: textbook.name,
                onBack: {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    TextbookScoreChart(data: data)
                    
                    NavigationLink {
                        QuizView(textbook: textbook)
                    } label: {
                        Text("学習開始")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .background(Color.pink.opacity(0.8))
                            .cornerRadius(5)
                    }
                    
                    HStack(spacing: 16) {
                        VStack {
                            Image(systemName: "square.3.layers.3d")
                                .foregroundStyle(.blue)
                            Text("\(viewModel.questionCount(of: textbook))")
                            Text("問題数")
                        }
                        .frame(maxWidth: .infinity)
                        .cardBackground()

                        VStack {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.red)
                            Text("-")
                            Text("学習回数")
                        }
                        .frame(maxWidth: .infinity)
                        .cardBackground()

                        VStack {
                            Image(systemName: "chart.bar.xaxis")
                                .foregroundStyle(.green)
                            Text("-")
                            Text("平均点")
                        }
                        .frame(maxWidth: .infinity)
                        .cardBackground()
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text("問題を追加")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(5)
                    
                    QuestionList(questions: textbook.questions)
                }
                .padding()
            }
            
            Spacer()
        }
        .fullBackground()
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    MyTextbookDetailView(textbook: feMock)
}
#Preview {
    MyTextbookDetailView(textbook: feMockMultiPattern)
}
