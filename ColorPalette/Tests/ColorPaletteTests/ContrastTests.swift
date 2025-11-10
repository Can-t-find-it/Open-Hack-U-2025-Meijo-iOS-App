import XCTest
import SwiftUI
@testable import ColorPalette

final class ContrastTests: XCTestCase {
    func testBodyTextContrast_Light() {
        assertContrast(fg: Themes.light.color(.primary),
                       bg: Themes.light.color(.primary),
                       minimum: 4.5)
    }

    // NOTE: This is a simplistic sRGB-based contrast; adjust tokens to pass as needed.
    private func assertContrast(fg: Color, bg: Color, minimum: Double,
                                file: StaticString = #file, line: UInt = #line) {
        let c = contrastRatio(fg, bg)
        XCTAssertGreaterThanOrEqual(c, minimum, "contrast=\(c)", file: file, line: line)
    }

    private func contrastRatio(_ a: Color, _ b: Color) -> Double {
        func luminance(_ c: Color) -> Double {
            #if canImport(UIKit)
            let ui = UIColor(c)
            var r: CGFloat = 0, g: CGFloat = 0, bl: CGFloat = 0, a: CGFloat = 0
            ui.getRed(&r, green: &g, blue: &bl, alpha: &a)
            #else
            // Fallback estimate for non-UIKit platforms
            return 1.0
            #endif
            func lin(_ v: CGFloat) -> Double {
                let v = Double(v)
                return v <= 0.04045 ? v/12.92 : pow((v+0.055)/1.055, 2.4)
            }
            let R = lin(r), G = lin(g), B = lin(bl)
            return 0.2126*R + 0.7152*G + 0.0722*B
        }
        let L1 = luminance(a), L2 = luminance(b)
        return (max(L1, L2) + 0.05) / (min(L1, L2) + 0.05)
    }
}
