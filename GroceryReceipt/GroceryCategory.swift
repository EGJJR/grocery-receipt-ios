import SwiftUI

enum GroceryCategory: String, CaseIterable {
    case produce = "PRODUCE"
    case dairy = "DAIRY"
    case meat = "MEAT"
    case bakery = "BAKERY"
    case pantry = "PANTRY"
    case other = "OTHER"

    var color: Color {
        switch self {
        case .produce: Color(red: 0.18, green: 0.62, blue: 0.34)
        case .dairy: Color(red: 0.22, green: 0.48, blue: 0.85)
        case .meat: Color(red: 0.82, green: 0.24, blue: 0.28)
        case .bakery: Color(red: 0.85, green: 0.55, blue: 0.18)
        case .pantry: Color(red: 0.55, green: 0.38, blue: 0.78)
        case .other: Color(red: 0.45, green: 0.45, blue: 0.48)
        }
    }

    static func guess(from name: String) -> GroceryCategory {
        let n = name.lowercased()
        let produce = ["apple", "banana", "carrot", "broccoli", "lettuce", "tomato", "onion", "pepper", "fruit", "veg", "spinach", "avocado", "potato"]
        let dairy = ["milk", "cheese", "butter", "yogurt", "cream", "egg"]
        let meat = ["chicken", "beef", "bacon", "pork", "fish", "salmon", "turkey", "steak"]
        let bakery = ["bread", "sourdough", "bagel", "roll", "muffin", "croissant"]
        let pantry = ["rice", "pasta", "sauce", "oil", "flour", "sugar", "cereal", "beans", "soy"]

        if produce.contains(where: { n.contains($0) }) { return .produce }
        if dairy.contains(where: { n.contains($0) }) { return .dairy }
        if meat.contains(where: { n.contains($0) }) { return .meat }
        if bakery.contains(where: { n.contains($0) }) { return .bakery }
        if pantry.contains(where: { n.contains($0) }) { return .pantry }
        return .other
    }
}

struct CategorizedItem: Identifiable {
    let index: Int
    let item: GroceryItem
    let category: GroceryCategory

    var id: UUID { item.id }
}

extension ReceiptMetadata {
    var categorizedItems: [CategorizedItem] {
        items.enumerated().map { offset, item in
            CategorizedItem(
                index: offset + 1,
                item: item,
                category: GroceryCategory.guess(from: item.name)
            )
        }
    }

    var categoryCounts: [(GroceryCategory, Int)] {
        let grouped = Dictionary(grouping: categorizedItems, by: \.category)
        return GroceryCategory.allCases.compactMap { category in
            guard let count = grouped[category]?.count, count > 0 else { return nil }
            return (category, count)
        }
    }
}
