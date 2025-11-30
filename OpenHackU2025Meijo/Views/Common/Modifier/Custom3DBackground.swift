import SwiftUI
import AppColorTheme

struct Custom3DBackground: ViewModifier {
    
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    
    var color = Color(.pink)
//    var color = AppColorToken.background.tabColor
    
    @State var rotation: CGFloat = 0.0
    
    func body(content: Content) -> some View {
        content
            .frame(width: width,height: height)
            .cornerRadius(cornerRadius)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [color.opacity(0.8), color.opacity(1.0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.0), Color.white.opacity(1)]),
                            startPoint: .bottom,
                            endPoint: .top
                        ),
                        lineWidth: 1
                    )
            )
    }
}

extension View {
    func custom3DBackground(width: CGFloat, height: CGFloat, cornerRadius: CGFloat) -> some View {
        modifier(Custom3DBackground(width: width, height: height, cornerRadius: cornerRadius))
    }
}

extension View {
    func cardBackground(
        cornerRadius: CGFloat = 20,
        lineWidth: CGFloat = 1,
        strokeOpacity: Double = 0.2,
        fillOpacity: Double = 0.1
    ) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.white.opacity(strokeOpacity), lineWidth: lineWidth)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white.opacity(fillOpacity))
                )
        )
    }
}


#Preview {
    TopView()
}
