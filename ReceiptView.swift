import SwiftUI
import UIKit

// MARK: - Receipt paper
// Shared between the animated preview and ImageRenderer for export.
struct ReceiptPaper: View {
    let items: [GroceryItem]
    let storeName: String
    let orderNumber: String
    let timestamp: String

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 14) {
                Image(systemName: "sparkle")
                    .font(.system(size: 28, weight: .black))
                    .padding(.top, 28)

                mono("GROCERY RECEIPT    \(orderNumber)", size: 12, bold: true)
                mono(timestamp, size: 11)

                dashes

                HStack {
                    mono("ITEM", size: 12, bold: true).frame(maxWidth: .infinity, alignment: .leading)
                    mono("QTY", size: 12, bold: true).frame(width: 44, alignment: .trailing)
                }

                dashes

                ForEach(items) { item in
                    HStack {
                        mono(item.name.uppercased().trimmingCharacters(in: .whitespaces), size: 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        mono(String(format: "%02d", item.qty), size: 12)
                            .frame(width: 44, alignment: .trailing)
                    }
                }

                dashes

                VStack(spacing: 6) {
                    mono(storeName.isEmpty ? "YOUR GROCERY STORE" : storeName.uppercased(), size: 12, bold: true)
                    mono("THANKS FOR SHOPPING", size: 11)
                }
                .padding(.bottom, 28)
            }
            .padding(.horizontal, 24)
        }
        .background(.white)
    }

    private var dashes: some View {
        mono(String(repeating: "· ", count: 26), size: 10)
            .foregroundStyle(Color.gray.opacity(0.5))
    }

    @ViewBuilder
    private func mono(_ text: String, size: CGFloat, bold: Bool = false) -> some View {
        Text(text)
            .font(bold
                  ? .custom("Courier New", size: size).bold()
                  : .custom("Courier New", size: size))
            .multilineTextAlignment(.center)
    }
}

// MARK: - Animated receipt screen
struct ReceiptView: View {
    let items: [GroceryItem]
    let storeName: String

    @State private var printProgress: CGFloat = 0
    @State private var orderNumber = String(format: "ORDER #%05d", Int.random(in: 10000...99999))
    @State private var timestamp: String = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd    HH:mm"
        return f.string(from: .now)
    }()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.93, blue: 0.91).ignoresSafeArea()

                ReceiptPaper(items: items, storeName: storeName, orderNumber: orderNumber, timestamp: timestamp)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.12), radius: 24, y: 12)
                    .padding(.horizontal, 28)
                    // ponytail: clip-height reveal = thermal printer illusion, per-row stagger only if this feels flat
                    .mask(revealMask)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Send") { shareReceipt() }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                let haptic = UIImpactFeedbackGenerator(style: .light)
                haptic.prepare()
                haptic.impactOccurred()
                withAnimation(.linear(duration: 1.4)) { printProgress = 1 }
            }
        }
    }

    private var revealMask: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Rectangle().frame(height: geo.size.height * printProgress)
                Spacer(minLength: 0)
            }
        }
    }

    @MainActor
    private func shareReceipt() {
        let renderer = ImageRenderer(
            content: ReceiptPaper(
                items: items,
                storeName: storeName,
                orderNumber: orderNumber,
                timestamp: timestamp
            ).frame(width: 360)
        )
        renderer.scale = 3 // ponytail: @3x, good enough for all current iPhones
        guard let image = renderer.uiImage else { return }

        let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow?.rootViewController?.present(av, animated: true)
    }
}
