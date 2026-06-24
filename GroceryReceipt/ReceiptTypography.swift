import SwiftUI

enum ReceiptTypography {
    static func mono(_ text: String, size: CGFloat, bold: Bool = false) -> Text {
        Text(text)
            .font(bold
                  ? .system(size: size, weight: .bold, design: .monospaced)
                  : .system(size: size, weight: .regular, design: .monospaced))
            .foregroundColor(ReceiptColors.paperText)
    }

    static func monoMuted(_ text: String, size: CGFloat) -> Text {
        Text(text)
            .font(.system(size: size, weight: .regular, design: .monospaced))
            .foregroundColor(ReceiptColors.mutedInk)
    }
}
