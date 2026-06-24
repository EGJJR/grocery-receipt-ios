import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ListBuilderView()
        }
        .tint(AppTheme.accent)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
