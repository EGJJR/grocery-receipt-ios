import SwiftUI

struct ListEmptyState: View {
    let onQuickAdd: (String) -> Void

    private let suggestions = [
        "milk, eggs & bread",
        "3 apples, bananas",
        "chicken, rice, broccoli",
    ]

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 8)

            ZStack {
                Circle()
                    .fill(AppTheme.accentSoft)
                    .overlay(Circle().stroke(AppTheme.accent.opacity(0.35), lineWidth: 2))
                    .frame(width: 112, height: 112)
                Image(systemName: "text.quote")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(AppTheme.accent)
            }

            VStack(spacing: 10) {
                Text("Start with a few items")
                    .font(.system(.title2, design: .serif).weight(.bold))
                    .foregroundColor(AppTheme.primaryText)

                Text("Type or tap the mic below.\nSay \"three apples and milk\" — we'll sort it out.")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("TRY SAYING")
                    .font(AppTypography.sectionLabel())
                    .foregroundColor(AppTheme.secondaryText)
                    .tracking(0.6)
                    .padding(.horizontal, 4)

                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        onQuickAdd(suggestion)
                    } label: {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(AppTheme.link)
                            Text(suggestion)
                                .foregroundColor(AppTheme.primaryText)
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(AppTheme.accent)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(AppTheme.cardElevated)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}

#Preview {
    ListEmptyState { _ in }
        .background(AppTheme.background)
}
