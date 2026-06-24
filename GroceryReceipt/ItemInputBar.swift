import SwiftUI

struct ItemInputBar: View {
    @Binding var draft: String
    let isRecording: Bool
    let onSubmit: () -> Void
    let onMicTap: () -> Void

    @FocusState private var isFocused: Bool

    private var canSubmit: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("ADD ITEMS")
                .font(AppTypography.sectionLabel())
                .foregroundColor(AppTheme.secondaryText)
                .tracking(0.6)
                .padding(.leading, 4)

            HStack(spacing: 12) {
                TextField("milk, eggs & bread…", text: $draft, axis: .vertical)
                    .lineLimit(1...3)
                    .textFieldStyle(.plain)
                    .foregroundColor(AppTheme.primaryText)
                    .tint(AppTheme.link)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit(onSubmit)

                Button(action: onMicTap) {
                    Image(systemName: isRecording ? "waveform.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(isRecording ? AppTheme.accentPressed : AppTheme.accent)
                        .scaleEffect(isRecording ? 1.08 : 1)
                        .animation(.easeInOut(duration: 0.2), value: isRecording)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isRecording ? "Stop recording" : "Start voice input")

                Button(action: onSubmit) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(canSubmit ? AppTheme.accent : AppTheme.disabled)
                }
                .buttonStyle(.plain)
                .disabled(!canSubmit)
                .accessibilityLabel("Add items")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(AppTheme.cardElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(isFocused ? AppTheme.accent.opacity(0.45) : AppTheme.border, lineWidth: 1.5)
                    )
                    .shadow(color: AppTheme.shadow, radius: 10, y: 4)
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var draft = "three apples"

        var body: some View {
            VStack {
                Spacer()
                ItemInputBar(draft: $draft, isRecording: false, onSubmit: {}, onMicTap: {})
            }
            .background(AppTheme.background)
        }
    }
    return PreviewWrapper()
}
