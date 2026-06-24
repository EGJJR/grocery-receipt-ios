import Foundation

enum GroceryItemParser {
    private static let numberWords: [String: Int] = [
        "a": 1, "an": 1, "one": 1, "two": 2, "three": 3, "four": 4,
        "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9,
        "ten": 10, "eleven": 11, "twelve": 12,
    ]

    static func parse(_ raw: String) -> [GroceryItem] {
        raw
            .split(whereSeparator: { ",;&\n".contains($0) })
            .flatMap { segment -> [GroceryItem] in
                let trimmed = segment
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: " and ", with: " ", options: .caseInsensitive)

                guard !trimmed.isEmpty else { return [] }

                let parts = trimmed.split(separator: " ")
                guard !parts.isEmpty else { return [] }

                var qty = 1
                var nameStart = 0

                if let first = parts.first?.lowercased(), let wordQty = numberWords[first] {
                    qty = wordQty
                    nameStart = 1
                } else if let first = parts.first,
                          let digitQty = Int(first),
                          parts.count > 1 {
                    qty = max(1, min(digitQty, 99))
                    nameStart = 1
                } else if let first = parts.first,
                          first.hasSuffix("x") || first.hasSuffix("X"),
                          let digitQty = Int(first.dropLast()) {
                    qty = max(1, min(digitQty, 99))
                    nameStart = 1
                }

                let name = parts.dropFirst(nameStart).joined(separator: " ")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                guard !name.isEmpty else { return [] }
                return [GroceryItem(name: name.capitalized, qty: qty)]
            }
    }

    static func merge(_ existing: [GroceryItem], with incoming: [GroceryItem]) -> [GroceryItem] {
        var result = existing
        for item in incoming {
            let key = item.name.lowercased()
            if let index = result.firstIndex(where: { $0.name.lowercased() == key }) {
                result[index].qty = min(99, result[index].qty + item.qty)
            } else {
                result.append(item)
            }
        }
        return result
    }
}
