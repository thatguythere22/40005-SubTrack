import Foundation

/// A personal-finance grouping used to help the user understand where recurring
/// subscription spending is concentrated.
enum SubscriptionCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case entertainment
    case music
    case cloudStorage
    case productivity
    case education
    case gaming
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .entertainment: return "Entertainment"
        case .music: return "Music"
        case .cloudStorage: return "Cloud Storage"
        case .productivity: return "Productivity"
        case .education: return "Education"
        case .gaming: return "Gaming"
        case .other: return "Other"
        }
    }
}
