import SwiftUI

public enum Palette {
    @MainActor
    public struct Text: DynamicProperty {
        @Environment(\.appTheme) private var theme
        public init() {}

        public var primary: Color   { theme.color(text: .primary) }
        public var secondary: Color { theme.color(text: .secondary) }
        public var inverse: Color   { theme.color(text: .inverse) }
        public var orange: Color    { theme.color(text: .orange) }
    }

    @MainActor
    public struct Background: DynamicProperty {
        @Environment(\.appTheme) private var theme
        public init() {}

        public var primary: Color { theme.color(background: .primary) }
        public var surface: Color { theme.color(background: .surface) }
        public var variant: Color { theme.color(background: .variant) }
    }

    @MainActor
    public struct Accent: DynamicProperty {
        @Environment(\.appTheme) private var theme
        public init() {}

        public var main: Color    { theme.color(accent: .main) }
        public var hover: Color   { theme.color(accent: .hover) }
        public var pressed: Color { theme.color(accent: .pressed) }
    }
}
