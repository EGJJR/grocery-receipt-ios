import SwiftUI

struct GroceryListRow: View {
    @Binding var item: GroceryItem
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.body.weight(.semibold))
                    .foregroundColor(AppTheme.primaryText)
                Text("Tap − or + to adjust")
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }

            Spacer()

            HStack(spacing: 0) {
                Button {
                    if item.qty > 1 {
                        item.qty -= 1
                        HapticManager.fire(.quantityChange)
                    } else {
                        onDelete()
                    }
                } label: {
                    Image(systemName: item.qty > 1 ? "minus" : "trash")
                        .font(.caption.weight(.bold))
                        .foregroundColor(AppTheme.accentOnSoft)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)

                Text("\(item.qty)")
                    .font(.title3.monospacedDigit().weight(.bold))
                    .foregroundColor(AppTheme.accentOnSoft)
                    .frame(minWidth: 28)

                Button {
                    if item.qty < 99 {
                        item.qty += 1
                        HapticManager.fire(.quantityChange)
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.caption.weight(.bold))
                        .foregroundColor(AppTheme.accentOnSoft)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(AppTheme.accentSoft)
                    .overlay(Capsule().stroke(AppTheme.accent.opacity(0.22), lineWidth: 1))
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.cardElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
                .shadow(color: AppTheme.shadow, radius: 6, y: 2)
        )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var item = GroceryItem.fixtureBacon

        var body: some View {
            GroceryListRow(item: $item, onDelete: {})
                .padding()
                .background(AppTheme.background)
        }
    }
    return PreviewWrapper()
}
