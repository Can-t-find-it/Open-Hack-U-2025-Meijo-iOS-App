import Foundation

public enum ColorToken {
    public enum TextColor {
        static let primary = ColorPalette.red
        static let secondary = ColorPalette.orange
        static let accent = ColorPalette.blue
        static let normal = ColorPalette.black
    }

    public enum BackgroundColor {
        static let primary = ColorPalette.white
        static let secondary = ColorPalette.orange
        static let accent = ColorPalette.blue
        static let surface = ColorPalette.purple
        static let tabColor = ColorPalette.midnight
    }
}
