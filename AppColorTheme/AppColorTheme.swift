import SwiftUI

public enum AppColorToken {}

public extension AppColorToken {
    enum text {
        public static var primary: Color { ColorToken.TextColor.primary }
        public static var secondary: Color { ColorToken.TextColor.secondary }
        public static var accent: Color { ColorToken.TextColor.accent }
        public static var normal: Color { ColorToken.TextColor.normal }
    }
    enum background {
        public static var primary: Color { ColorToken.BackgroundColor.primary }
        public static var secondary: Color { ColorToken.BackgroundColor.secondary }
        public static var accent: Color { ColorToken.BackgroundColor.accent }
        public static var surface: Color { ColorToken.BackgroundColor.surface }
        public static var tabColor: Color { ColorToken.BackgroundColor.tabColor }
    }
}
