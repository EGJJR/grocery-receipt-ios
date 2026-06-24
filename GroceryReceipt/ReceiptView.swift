import SwiftUI
import UIKit

struct ReceiptView: View {
    let items: [GroceryItem]
    let storeName: String
    let listTitle: String

    @Environment(\.dismiss) private var dismiss

    @State private var printProgress: CGFloat = 0
    @State private var metadata: ReceiptMetadata?
    @State private var sharePayload: SharePayload?

    var body: some View {
        NavigationStack {
            ZStack {
                ReceiptColors.canvas.ignoresSafeArea()

                if let metadata {
                    ScrollView {
                        ReceiptPrinterAssembly(metadata: metadata, storeName: storeName)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                    }
                    .mask(revealMask)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Send") { shareReceipt() }
                        .disabled(metadata == nil)
                }
            }
        }
        .task { await runPrintAnimation() }
        .sheet(item: $sharePayload) { payload in
            ActivityShareSheet(image: payload.image)
                .presentationDetents([.medium, .large])
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

    private func runPrintAnimation() async {
        metadata = ReceiptMetadata.generate(for: items, listTitle: listTitle)
        try? await Task.sleep(for: .milliseconds(150))
        guard !Task.isCancelled else { return }
        HapticManager.fire(.printStart)
        withAnimation(.linear(duration: 1.6)) {
            printProgress = 1
        }
    }

    @MainActor
    private func shareReceipt() {
        guard let metadata else { return }

        let renderer = ImageRenderer(
            content: ReceiptPrinterAssembly(metadata: metadata, storeName: storeName)
                .frame(width: 340)
                .padding(.vertical, 24)
                .background(ReceiptColors.canvas)
        )
        renderer.scale = 3
        guard let image = renderer.uiImage else { return }

        HapticManager.fire(.share)
        sharePayload = SharePayload(image: image)
    }
}

struct SharePayload: Identifiable {
    let id = UUID()
    let image: UIImage
}

// MARK: - Previews

#Preview("Printing") {
    ReceiptView(items: GroceryItem.fixtures, storeName: "", listTitle: "Saturday Run")
}

#Preview("Fully printed") {
    ScrollView {
        ReceiptPrinterAssembly(metadata: .preview, storeName: "")
            .frame(width: 340)
            .padding()
    }
    .background(ReceiptColors.canvas)
}
