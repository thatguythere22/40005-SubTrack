import Foundation

/// Whether a recurring subscription currently contributes to the user's active
/// financial commitments.
enum SubscriptionStatus: String, Codable {
    case active
    case inactive
}
