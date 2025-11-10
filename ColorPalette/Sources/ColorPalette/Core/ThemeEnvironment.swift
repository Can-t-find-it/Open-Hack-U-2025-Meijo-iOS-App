import SwiftUI

@MainActor
private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = Themes.light
}

@MainActor
public extension EnvironmentValues {
    var appTheme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

@MainActor
public extension View {
    func appTheme(_ theme: Theme) -> some View {
        environment(\.appTheme, theme)
    }
}
