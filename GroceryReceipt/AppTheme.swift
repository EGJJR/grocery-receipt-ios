import SwiftUI

// Mobbin-informed palette: Goodreads cream, komoot olive, Beli slate, Tolan brown ink
enum AppTheme {
    // Surfaces
    static let background = Color(red: 0.96, green: 0.93, blue: 0.89)
    static let card = Color(red: 1.0, green: 0.99, blue: 0.97)
    static let cardElevated = Color.white

    // Ink
    static let primaryText = Color(red: 0.18, green: 0.14, blue: 0.12)
    static let secondaryText = Color(red: 0.42, green: 0.37, blue: 0.33)
    static let disabled = Color(red: 0.62, green: 0.58, blue: 0.54)

    // Accent — komoot olive with Beli slate for interactive elements
    static let accent = Color(red: 0.29, green: 0.36, blue: 0.14)
    static let accentPressed = Color(red: 0.22, green: 0.28, blue: 0.11)
    static let accentSoft = Color(red: 0.88, green: 0.91, blue: 0.80)
    static let accentOnSoft = Color(red: 0.24, green: 0.30, blue: 0.12)
    static let link = Color(red: 0.17, green: 0.31, blue: 0.37)

    // Structure
    static let border = Color(red: 0.18, green: 0.14, blue: 0.12).opacity(0.12)
    static let shadow = Color(red: 0.18, green: 0.14, blue: 0.12).opacity(0.10)
}

enum AppTypography {
    static func screenTitle() -> Font {
        .system(.largeTitle, design: .serif).weight(.bold)
    }

    static func listName() -> Font {
        .system(.title, design: .serif).weight(.bold)
    }

    static func sectionLabel() -> Font {
        .caption.weight(.semibold)
    }

    static func body() -> Font {
        .body
    }
}

enum ReceiptColors {
    static let canvas = Color(red: 0.90, green: 0.88, blue: 0.85)
    static let slot = Color(red: 0.08, green: 0.08, blue: 0.09)
    static let dash = Color.black.opacity(0.35)
    static let paperText = Color(red: 0.06, green: 0.06, blue: 0.08)
    static let mutedInk = Color(red: 0.35, green: 0.35, blue: 0.38)
}
