import SwiftUI

struct ListTitleField: View {
    @Binding var title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("LIST NAME")
                .font(AppTypography.sectionLabel())
                .foregroundColor(AppTheme.secondaryText)
                .tracking(0.6)

            TextField("Untitled list", text: $title)
                .font(AppTypography.listName())
                .foregroundColor(AppTheme.primaryText)
                .tint(AppTheme.link)
                .textFieldStyle(.plain)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.cardElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var title = "Saturday Run"

        var body: some View {
            ListTitleField(title: $title)
                .background(AppTheme.background)
        }
    }
    return PreviewWrapper()
}
