import UIKit

@MainActor
enum HapticManager {
    enum HapticType {
        case itemAdded
        case itemRemoved
        case quantityChange
        case micStart
        case micStop
        case printStart
        case share
        case success
        case error
    }

    private static let selection = UISelectionFeedbackGenerator()
    private static let light = UIImpactFeedbackGenerator(style: .light)
    private static let medium = UIImpactFeedbackGenerator(style: .medium)
    private static let notification = UINotificationFeedbackGenerator()

    static func fire(_ type: HapticType) {
        switch type {
        case .itemAdded, .quantityChange:
            selection.selectionChanged()
        case .itemRemoved:
            light.impactOccurred()
        case .micStart:
            medium.impactOccurred(intensity: 0.7)
        case .micStop:
            light.impactOccurred()
        case .printStart:
            light.impactOccurred()
        case .share:
            medium.impactOccurred()
        case .success:
            notification.notificationOccurred(.success)
        case .error:
            notification.notificationOccurred(.error)
        }
    }
}
