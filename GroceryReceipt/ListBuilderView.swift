import SwiftUI

struct ListBuilderView: View {
    @State private var items: [GroceryItem] = []
    @State private var listTitle = "My List"
    @State private var draft = ""
    @State private var receiptDraft: ReceiptDraft?
    @State private var toastMessage: String?
    @StateObject private var speech = SpeechRecognizer()

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    screenHeader
                    ListTitleField(title: $listTitle)

                    if items.isEmpty {
                        ListEmptyState { quickAdd($0) }
                    } else {
                        listStats
                        itemsList
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 120)
            }
            .scrollDismissesKeyboard(.interactively)

            if let toastMessage {
                ToastBanner(message: toastMessage)
                    .padding(.bottom, 88)
                    .zIndex(1)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar { toolbarContent }
        .safeAreaInset(edge: .bottom) {
            ItemInputBar(
                draft: $draft,
                isRecording: speech.isRecording,
                onSubmit: submitDraft,
                onMicTap: handleMicTap
            )
        }
        .sheet(item: $receiptDraft) { draft in
            ReceiptView(
                items: draft.items,
                storeName: draft.storeName,
                listTitle: draft.listTitle
            )
        }
        .onChange(of: speech.transcript) { newValue in
            if !newValue.isEmpty {
                draft = newValue
            }
        }
        .task {
            await speech.requestAuthorization()
        }
        .onDisappear {
            speech.stopRecording()
        }
    }

    // MARK: - Sections

    private var screenHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your list")
                .font(AppTypography.screenTitle())
                .foregroundColor(AppTheme.primaryText)

            Text("Type or speak items, then print a receipt to share.")
                .font(.subheadline)
                .foregroundColor(AppTheme.secondaryText)
        }
        .padding(.horizontal, 20)
    }

    private var listStats: some View {
        HStack {
            Label("\(items.count) items", systemImage: "list.bullet")
            Spacer()
            Label("\(totalQuantity) total qty", systemImage: "number")
        }
        .font(.caption.weight(.semibold))
        .foregroundColor(AppTheme.secondaryText)
        .padding(.horizontal, 24)
    }

    private var itemsList: some View {
        LazyVStack(spacing: 12) {
            ForEach($items) { $item in
                GroceryListRow(item: $item) {
                    removeItem(item)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button {
                receiptDraft = ReceiptDraft(
                    items: items,
                    storeName: "",
                    listTitle: listTitle
                )
            } label: {
                Label("Print", systemImage: "printer.fill")
            }
            .disabled(items.isEmpty)
            .foregroundColor(AppTheme.accent)
        }

        if !items.isEmpty {
            ToolbarItem(placement: .topBarLeading) {
                Button("Clear", role: .destructive) {
                    withAnimation {
                        items.removeAll()
                    }
                    HapticManager.fire(.itemRemoved)
                }
            }
        }
    }

    private var totalQuantity: Int {
        items.reduce(0) { $0 + $1.qty }
    }

    // MARK: - Actions

    private func submitDraft() {
        let parsed = GroceryItemParser.parse(draft)
        guard !parsed.isEmpty else { return }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            items = GroceryItemParser.merge(items, with: parsed)
        }

        draft = ""
        speech.stopRecording()
        showToast("Added \(parsed.count) item\(parsed.count == 1 ? "" : "s")")
        HapticManager.fire(.success)
    }

    private func quickAdd(_ text: String) {
        draft = text
        submitDraft()
    }

    private func handleMicTap() {
        switch speech.authorizationStatus {
        case .authorized:
            speech.toggleRecording()
        case .notDetermined:
            Task {
                await speech.requestAuthorization()
                if speech.authorizationStatus == .authorized {
                    speech.startRecording()
                }
            }
        default:
            HapticManager.fire(.error)
        }
    }

    private func removeItem(_ item: GroceryItem) {
        withAnimation {
            items.removeAll { $0.id == item.id }
        }
        HapticManager.fire(.itemRemoved)
    }

    private func showToast(_ message: String) {
        withAnimation {
            toastMessage = message
        }
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation {
                toastMessage = nil
            }
        }
    }
}

#Preview("Empty") {
    NavigationStack {
        ListBuilderView()
    }
    .tint(AppTheme.accent)
}

#Preview("With items") {
    NavigationStack {
        ListBuilderView()
    }
    .tint(AppTheme.accent)
}
