import SwiftUI

struct SlideMenu: View {
    @State private var width: CGFloat = 50
    let maxWidth: CGFloat = 370

    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .opacity(width > 0 ? 1 : 0)
                    .animation(.easeOut, value: width)

                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Home")
                        Text("Profile")
                        Text("Settings")
                    }
                    .padding()
                    .frame(width: width)
                    .background(Color.white)
                }
            }
            .animation(.easeOut(duration: 0.4), value: width)
            .onTapGesture {
                width = 50
            }
            .toolbar {
                Button("Open") {
                    width = maxWidth
                }
            }
        }
    }
}

#Preview {
    SlideMenu()
}
