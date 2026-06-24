import SwiftUI

struct ReceiptPaper: View {
    let metadata: ReceiptMetadata
    let storeName: String

    private var itemCount: Int {
        metadata.items.reduce(0) { $0 + $1.qty }
    }

    private var subtitle: String {
        let title = storeName.isEmpty ? metadata.listTitle : storeName.uppercased()
        return "\(metadata.timeText)  ·  \(title)"
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 14) {
                ReceiptLogo()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)

                ReceiptTypography.mono("YOUR GROCERY RECEIPT", size: 13, bold: true)
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(alignment: .leading, spacing: 4) {
                    ReceiptTypography.mono(metadata.orderNumber, size: 10)
                    ReceiptTypography.mono(metadata.dateText, size: 10)
                    ReceiptTypography.mono(subtitle, size: 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ReceiptDashes()

                ReceiptColumnHeader()

                ReceiptDashes()

                ForEach(metadata.categorizedItems) { row in
                    ReceiptItemRow(row: row)
                }

                ReceiptDashes()

                ReceiptSummaryRow(label: "TOTAL ITEMS", value: String(format: "%02d", itemCount))
                ReceiptSummaryRow(label: "UNIQUE LINES", value: String(format: "%02d", metadata.items.count))

                if !metadata.categoryCounts.isEmpty {
                    ReceiptDashes()
                    ReceiptCategorySection(counts: metadata.categoryCounts)
                }

                ReceiptDashes()

                VStack(spacing: 6) {
                    ReceiptTypography.mono("THANKS FOR SHOPPING", size: 10, bold: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                    ReceiptTypography.monoMuted("ONE LIST · ONE RECEIPT", size: 9)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.white)
    }
}

// MARK: - Rows

private struct ReceiptColumnHeader: View {
    var body: some View {
        HStack(spacing: 0) {
            ReceiptTypography.mono("ITEM", size: 10, bold: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            ReceiptTypography.mono("QTY", size: 10, bold: true)
                .frame(width: 32, alignment: .trailing)
            ReceiptTypography.mono("CAT", size: 10, bold: true)
                .frame(width: 28, alignment: .trailing)
        }
    }
}

private struct ReceiptItemRow: View {
    let row: CategorizedItem

    var body: some View {
        HStack(spacing: 0) {
            ReceiptTypography.mono(
                "\(row.index). \(row.item.name.uppercased())",
                size: 10
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(2)
            .minimumScaleFactor(0.85)

            ReceiptTypography.mono(String(format: "%02d", row.item.qty), size: 10)
                .frame(width: 32, alignment: .trailing)

            Circle()
                .fill(row.category.color)
                .frame(width: 8, height: 8)
                .frame(width: 28, alignment: .trailing)
        }
        .padding(.vertical, 2)
    }
}

private struct ReceiptSummaryRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            ReceiptTypography.mono(label, size: 10, bold: true)
            Spacer()
            ReceiptTypography.mono(value, size: 10, bold: true)
        }
    }
}

private struct ReceiptCategorySection: View {
    let counts: [(GroceryCategory, Int)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ReceiptTypography.mono("CATEGORIES", size: 10, bold: true)

            ForEach(counts, id: \.0) { category, count in
                HStack(spacing: 8) {
                    Circle()
                        .fill(category.color)
                        .frame(width: 8, height: 8)
                    ReceiptTypography.mono(category.rawValue, size: 9)
                    Spacer()
                    ReceiptTypography.mono(String(format: "%02d", count), size: 9)
                }
            }
        }
    }
}

// MARK: - Chrome

private struct ReceiptLogo: View {
    var body: some View {
        Image(systemName: "cart.fill")
            .font(.system(size: 28, weight: .black))
            .foregroundColor(ReceiptColors.paperText)
    }
}

struct ReceiptDashes: View {
    var body: some View {
        ReceiptTypography.mono(String(repeating: "· ", count: 28), size: 9)
            .foregroundColor(ReceiptColors.dash)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Printer assembly

struct ReceiptPrinterAssembly: View {
    let metadata: ReceiptMetadata
    let storeName: String

    var body: some View {
        VStack(spacing: 0) {
            ReceiptPrinterSlot()

            ReceiptPaper(metadata: metadata, storeName: storeName)
                .shadow(color: .black.opacity(0.06), radius: 1, y: 1)
                .shadow(color: .black.opacity(0.10), radius: 20, y: 12)
        }
    }
}

private struct ReceiptPrinterSlot: View {
    var body: some View {
        Rectangle()
            .fill(ReceiptColors.slot)
            .frame(height: 22)
    }
}

// MARK: - Previews

#Preview("Receipt paper") {
    ScrollView {
        ReceiptPaper(metadata: .preview, storeName: "")
            .frame(width: 340)
    }
    .background(ReceiptColors.canvas)
}

#Preview("Printer assembly") {
    ScrollView {
        ReceiptPrinterAssembly(metadata: .preview, storeName: "")
            .frame(width: 340)
    }
    .background(ReceiptColors.canvas)
}
