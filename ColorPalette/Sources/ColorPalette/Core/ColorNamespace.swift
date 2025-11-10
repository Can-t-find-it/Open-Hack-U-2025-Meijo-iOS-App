import SwiftUI

public enum ColorNamespace {
    public enum Text: Hashable {
        case primary, secondary, inverse, orange
    }
    public enum Background: Hashable {
        case primary, surface, variant
    }
    public enum Accent: Hashable {
        case main, hover, pressed
    }
}
