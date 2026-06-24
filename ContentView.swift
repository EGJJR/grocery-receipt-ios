import SwiftUI

struct ContentView: View {
    @State private var items: [GroceryItem] = [GroceryItem()]
    @State private var storeName = ""
    @State private var showReceipt = false

    var filledItems: [GroceryItem] {
        items.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Store") {
                    TextField("Store name (optional)", text: $storeName)
                }
                Section("Items") {
                    ForEach($items) { $item in
                        HStack(spacing: 12) {
                            TextField("Item", text: $item.name)
                            Stepper(value: $item.qty, in: 1...99) {
                                Text("\(item.qty)")
                                    .monospacedDigit()
                                    .frame(minWidth: 28)
                            }
                        }
                    }
                    .onDelete { items.remove(atOffsets: $0) }
                }
            }
            .navigationTitle("Grocery List")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        items.append(GroceryItem())
                    } label: {
                        Label("Add Item", systemImage: "plus.circle.fill")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Preview & Send") { showReceipt = true }
                        .disabled(filledItems.isEmpty)
                }
            }
            .sheet(isPresented: $showReceipt) {
                ReceiptView(items: filledItems, storeName: storeName)
            }
        }
    }
}
