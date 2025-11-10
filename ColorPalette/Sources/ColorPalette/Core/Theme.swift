import SwiftUI

@MainActor
public struct Theme {
    let textColors: [ColorNamespace.Text: Color]
    let backgroundColors: [ColorNamespace.Background: Color]
    let accentColors: [ColorNamespace.Accent: Color]

    public init(textColors: [ColorNamespace.Text: Color],
                backgroundColors: [ColorNamespace.Background: Color],
                accentColors: [ColorNamespace.Accent: Color]) {
        self.textColors = textColors
        self.backgroundColors = backgroundColors
        self.accentColors = accentColors
    }

    public func color(text token: ColorNamespace.Text) -> Color {
        textColors[token] ?? .clear
    }
    public func color(background token: ColorNamespace.Background) -> Color {
        backgroundColors[token] ?? .clear
    }
    public func color(accent token: ColorNamespace.Accent) -> Color {
        accentColors[token] ?? .clear
    }
}

@MainActor
public enum Themes {
    public static var light: Theme {
        Theme(
            textColors: [
                .primary: Color(hex: 0x111113),
                .secondary: Color(hex: 0x5A5A66),
                .inverse: Color(hex: 0xFFFFFF),
                .orange: Color(hex: 0xE57C23),
            ],
            backgroundColors: [
                .primary: Color(hex: 0xFFFFFF),
                .surface: Color(hex: 0xF7F7FA),
                .variant: Color(hex: 0xEDEDF2),
            ],
            accentColors: [
                .main: Color(hex: 0x563798),
                .hover: Color(hex: 0x4C2F86),
                .pressed: Color(hex: 0x3F2571),
            ]
        )
    }

    public static var dark: Theme {
        Theme(
            textColors: [
                .primary: Color(hex: 0xF4F4F7),
                .secondary: Color(hex: 0xB6B6C2),
                .inverse: Color(hex: 0x0D0D10),
                .orange: Color(hex: 0xF19A3E),
            ],
            backgroundColors: [
                .primary: Color(hex: 0x0D0D10),
                .surface: Color(hex: 0x141419),
                .variant: Color(hex: 0x1C1C24),
            ],
            accentColors: [
                .main: Color(hex: 0xAB8CFF),
                .hover: Color(hex: 0x9B7FE5),
                .pressed: Color(hex: 0x8B72CC),
            ]
        )
    }
}
