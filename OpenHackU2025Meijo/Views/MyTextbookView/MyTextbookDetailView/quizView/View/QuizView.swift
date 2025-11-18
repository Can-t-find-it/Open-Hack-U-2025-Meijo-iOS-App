import SwiftUI

struct QuizView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let textbook: MyTextbook
    @State private var viewModel = MyTextbookViewViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    Text(textbook.name)
                        .font(.headline).fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("/\(viewModel.questionCount(of: textbook))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // ProgressView
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.pink).opacity(0.5), Color(.pink).opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            VStack {
                VStack {
                    Text("問題")
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text("問題文")
                        .foregroundStyle(.white)
                        .font(.title2).fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .cardBackground()
                
                VStack {
                    Text("選択肢から答えを選んでください")
                        .foregroundStyle(.white)
                    
                    VStack(spacing: 16) {
                        Text("A")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                        Text("B")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                        Text("C")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                        Text("D")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(5)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .fullBackground()
        .navigationBarHidden(true)
    }
}

#Preview {
    QuizView(textbook: feMock)
}
