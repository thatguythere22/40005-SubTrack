import SwiftUI

extension SubscriptionCategory {
    var systemImageName: String {
        switch self {
        case .entertainment: return "tv"
        case .music: return "music.note"
        case .cloudStorage: return "icloud"
        case .productivity: return "checkmark.circle"
        case .education: return "graduationcap"
        case .gaming: return "gamecontroller"
        case .other: return "square.grid.2x2"
        }
    }
}
