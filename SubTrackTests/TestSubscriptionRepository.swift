import Foundation
@testable import SubTrack

final class TestSubscriptionRepository: SubscriptionRepository {
    var subscriptions: [Subscription]
    var shouldFailFetch = false
    var shouldFailSave = false

    init(subscriptions: [Subscription] = []) {
        self.subscriptions = subscriptions
    }

    func fetchSubscriptions() throws -> [Subscription] {
        if shouldFailFetch { throw TestRepositoryError.forcedFailure }
        return subscriptions
    }

    func save(_ subscription: Subscription) throws {
        if shouldFailSave { throw TestRepositoryError.forcedFailure }
        subscriptions.append(subscription)
    }

    func replaceAll(_ subscriptions: [Subscription]) throws {
        self.subscriptions = subscriptions
    }
}

enum TestRepositoryError: Error {
    case forcedFailure
}

func makeTestDate(year: Int = 2026, month: Int, day: Int) -> Date {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    return calendar.date(from: DateComponents(year: year, month: month, day: day))!
}
