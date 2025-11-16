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
            
            Spacer()
        }
        .fullBackground()
        .navigationBarHidden(true)
    }
}

#Preview {
    QuizView(textbook: feMock)
}
