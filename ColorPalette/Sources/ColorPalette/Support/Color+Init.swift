import SwiftUI

public extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex & 0xFF0000) >> 16) / 255.0
        let g = Double((hex & 0x00FF00) >> 8)  / 255.0
        let b = Double(hex & 0x0000FF)        / 255.0
        self = Color(.displayP3, red: r, green: g, blue: b, opacity: alpha)
    }
}

#if canImport(UIKit)
import UIKit
public extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8)  / 255.0
        let b = CGFloat(hex & 0x0000FF)        / 255.0
        self.init(displayP3Red: r, green: g, blue: b, alpha: alpha)
    }
}
#endif
