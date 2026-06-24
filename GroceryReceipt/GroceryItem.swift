import Foundation

struct GroceryItem: Identifiable, Hashable {
    var id = UUID()
    var name: String = ""
    var qty: Int = 1
}

// MARK: - Sheet payload

struct ReceiptDraft: Identifiable {
    let id = UUID()
    let items: [GroceryItem]
    let storeName: String
    let listTitle: String
}

// MARK: - Fixtures

extension GroceryItem {
    static let fixtureBacon = GroceryItem(name: "Bacon", qty: 4)
    static let fixtureCarrots = GroceryItem(name: "Carrots", qty: 3)
    static let fixtureSourdough = GroceryItem(name: "Sourdough", qty: 3)
    static let fixtureSoySauce = GroceryItem(name: "Soy Sauce", qty: 1)
    static let fixtureButter = GroceryItem(name: "Butter", qty: 3)

    static let fixtures: [GroceryItem] = [
        fixtureBacon,
        fixtureCarrots,
        fixtureSourdough,
        fixtureSoySauce,
        fixtureButter,
    ]
}

extension ReceiptDraft {
    static let preview = ReceiptDraft(
        items: GroceryItem.fixtures,
        storeName: "",
        listTitle: "Saturday Run"
    )
}
