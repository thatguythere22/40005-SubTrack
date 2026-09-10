import Foundation

/// Persistent implementation of the subscription record store used by the MVP.
/// A reference type is used because one shared store is used across multiple screens.
final class UserDefaultsSubscriptionRepository: SubscriptionRepository {
    private let defaults: UserDefaults
    private let storageKey: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(
        defaults: UserDefaults = .standard,
        storageKey: String = "subtrack.subscriptions"
    ) {
        self.defaults = defaults
        self.storageKey = storageKey
    }

    func fetchSubscriptions() throws -> [Subscription] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }
        return try decoder.decode([Subscription].self, from: data)
    }

    func save(_ subscription: Subscription) throws {
        var subscriptions = try fetchSubscriptions()
        subscriptions.append(subscription)
        try replaceAll(subscriptions)
    }

    func replaceAll(_ subscriptions: [Subscription]) throws {
        let data = try encoder.encode(subscriptions)
        defaults.set(data, forKey: storageKey)
    }
}
