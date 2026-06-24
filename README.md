# grocery-receipt-ios

A SwiftUI app to compose grocery lists styled as thermal receipts and share them with your partner via iMessage, AirDrop, or any iOS share sheet.

## Features

- Add items with name and quantity
- Animated thermal printer reveal effect on preview
- Haptic feedback during "printing"
- Exports receipt as an image via the iOS share sheet
- Zero backend — no accounts, no server

## Screenshots

> Receipt preview with thermal print animation → share as image to iMessage

## Requirements

- iOS 16+
- Xcode 14+

## Setup

1. Clone the repo
2. Open Xcode → New Project → App (SwiftUI, iOS 16+)
3. Drop `GroceryItem.swift`, `ContentView.swift`, and `ReceiptView.swift` into the project
4. Replace the generated `ContentView` — done

## How it works

| File | Role |
|---|---|
| `GroceryItem.swift` | Model — name + qty |
| `ContentView.swift` | Edit screen — add/remove items, store name |
| `ReceiptView.swift` | Receipt UI with print animation + share button |

**Share flow:** `ImageRenderer` snapshots `ReceiptPaper` → `UIImage` → `UIActivityViewController` → partner receives receipt image.

**Print animation:** `ReceiptPaper` is masked with a growing `Rectangle` over 1.4s using `.linear` animation, giving the thermal printer paper-feed illusion.

## License

MIT
