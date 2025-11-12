import SwiftUI

struct PenaltyListView: View {
    var body: some View {
        VStack {
            VStack {
                Rectangle()
                    .frame(height: 240)
                    .cornerRadius(20)
                    .overlay {
                        Image(systemName: "arrowtriangle.right.circle.fill")
                            .foregroundStyle(.pink)
                            .font(.title)
                    }
                
                HStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.pink)
                                .font(.system(size: 25))
                        }
                    
                    VStack {
                        Text("username")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        Text("timestamp")
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
        .fullBackground()
    }
}

#Preview {
    PenaltyListView()
}
