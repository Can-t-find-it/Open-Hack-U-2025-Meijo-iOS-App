import SwiftUI

public struct PalettePreview: View {
    @Environment(\.colorScheme) private var scheme
    @Palette.Text public var text
    @Palette.Background public var background
    @Palette.Accent public var accent

    public init() {}

    public var body: some View {
        VStack(spacing: 16) {
            Text("Title").font(.title).foregroundStyle(text.primary)
            Text("Secondary").foregroundStyle(text.secondary)
            Button("Accent Button") {}
                .padding(.vertical, 10).padding(.horizontal, 16)
                .background(accent.main)
                .foregroundStyle(text.inverse)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding()
        .background(background.surface)
        .appTheme(scheme == .dark ? Themes.dark : Themes.light)
    }
}

#Preview {
    PalettePreview()
}
