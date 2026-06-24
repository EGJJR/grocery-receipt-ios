import Foundation

struct GroceryItem: Identifiable {
    var id = UUID()
    var name: String = ""
    var qty: Int = 1
}
