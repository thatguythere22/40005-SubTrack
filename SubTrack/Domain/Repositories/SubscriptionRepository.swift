import Foundation

/// The persistence boundary for subscription records used by SubTrack's business operations.
protocol SubscriptionRepository {
    func fetchSubscriptions() throws -> [Subscription]
    func save(_ subscription: Subscription) throws
    func replaceAll(_ subscriptions: [Subscription]) throws
}
