import Testing
@testable import AppColorTheme
import SwiftUI

struct AppColorThemeTests {

    @Test("ColorPaletteの定義が正しいことを確認")
    func colorPaletteValues() throws {
        #expect(ColorPalette.white == Color(hex: "FFFFFF"))
        #expect(ColorPalette.black == Color(hex: "000000"))
    }

    @Test("text.primary が red を指していること")
    func textPrimaryColor() throws {
        #expect(ColorToken.TextColor.primary == ColorPalette.red)
    }

    @Test("background.surface が white を指していること")
    func backgroundSurfaceColor() throws {
        #expect(ColorToken.BackgroundColor.surface == ColorPalette.white)
    }

}
