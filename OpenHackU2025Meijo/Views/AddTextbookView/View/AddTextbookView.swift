import SwiftUI
import AppColorTheme

struct AddTextbookView: View {
    @State private var prompt: String = ""
    var body: some View {
        VStack {
            VStack {
                HStack {
                    
                    Spacer()
                    
                    Text("友達の問題集一覧")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
                
                ZStack(alignment: .trailing) {
                    TextField("例) 基本情報技術者試験", text: $prompt)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .padding(.trailing, 40)
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(AppColorToken.background.surface)
                        .font(.system(size: 28))
                        .padding(.trailing, 10)
                }
            }
            .padding()
            
            Spacer()
        }
        .fullBackground()
    }
}

#Preview {
    AddTextbookView()
}
