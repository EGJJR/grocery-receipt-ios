import Foundation

struct ReceiptMetadata: Hashable {
    let items: [GroceryItem]
    let orderNumber: String
    let dateText: String
    let timeText: String
    let listTitle: String

    static func generate(for items: [GroceryItem], listTitle: String, at date: Date = .now) -> ReceiptMetadata {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let dateLine = dateFormatter.string(from: date).uppercased()

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        return ReceiptMetadata(
            items: items,
            orderNumber: String(format: "ORDER:#%04d", Int.random(in: 1000...9999)),
            dateText: dateLine,
            timeText: timeFormatter.string(from: date),
            listTitle: listTitle.uppercased()
        )
    }

    static let preview = ReceiptMetadata(
        items: GroceryItem.fixtures,
        orderNumber: "ORDER:#4742",
        dateText: "FEBRUARY 20, 2026",
        timeText: "18:51",
        listTitle: "SATURDAY RUN"
    )
}
