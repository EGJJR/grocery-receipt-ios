# grocery-receipt-ios

A SwiftUI app to build lists by voice or text, print them as thermal receipts, and share via iMessage, AirDrop, or any iOS share sheet.

## Features

- Voice and text input — say *"three apples and milk"* or type comma-separated items
- Smart parsing — quantities from numbers and words (`3 eggs`, `two avocados`)
- Animated thermal printer reveal on preview
- Receipt export as a shareable image (ITEM + QTY, no prices)
- Category dots and numbered rows on the receipt
- Haptic feedback for add, record, print, and share
- No backend — no accounts, no server

## Requirements

- iOS 16+
- Xcode 15+

## Setup

1. Clone the repo
2. Open `GroceryReceipt.xcodeproj` in Xcode
3. Select your **Development Team** in Signing & Capabilities
4. Choose a simulator or device, then press **⌘R**

## Project structure

```
GroceryReceipt/
├── GroceryReceiptApp.swift    # @main entry point
├── ContentView.swift          # App shell
├── ListBuilderView.swift      # Main list-building flow
├── ListTitleField.swift       # Editable list name
├── ItemInputBar.swift         # Bottom text + mic composer
├── SpeechRecognizer.swift     # Voice input (Speech framework)
├── GroceryItemParser.swift    # Text → items parser
├── ReceiptView.swift          # Print animation + share sheet
├── ReceiptPaper.swift         # Receipt layout + printer chrome
├── AppTheme.swift             # Colors and typography tokens
└── Assets.xcassets/
```

## How it works

| Flow | Detail |
|---|---|
| **Add items** | `GroceryItemParser` splits on commas/`and`, extracts qty, merges duplicates |
| **Voice** | `SpeechRecognizer` streams transcript into the input bar |
| **Print** | `ReceiptPaper` masked with a growing `Rectangle` over ~1.4s |
| **Share** | `ImageRenderer` snapshots the receipt → `UIActivityViewController` |

## License

MIT
