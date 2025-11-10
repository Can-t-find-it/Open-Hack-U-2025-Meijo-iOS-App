# ``ColorPalette``

Reusable **meaning-based color tokens** with theme switching for SwiftUI apps.

## Overview

- Define colors by *meaning* (text/background/accent), not raw hex.
- Switch themes via environment: `.appTheme(Themes.dark)`.
- Use ergonomic accessors in views:
  ```swift
  struct Example: View {
    @Palette.Text var text
    @Palette.Background var background
    @Palette.Accent var accent

    var body: some View {
      Text("Hello").foregroundStyle(text.primary)
        .padding().background(background.surface)
    }
  }
  ```

## Topics

### Getting Started
- ``Palette``
- ``Theme``
- ``Themes``
