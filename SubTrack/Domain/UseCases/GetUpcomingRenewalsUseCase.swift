import Foundation

/// Errors that prevent SubTrack from showing a meaningful upcoming-renewal window.
enum UpcomingRenewalsError: LocalizedError, Equatable {
    case invalidWindow(days: Int)
    case unableToLoadSubscriptions

    var errorDescription: String? {
        switch self {
        case .invalidWindow:
            return "Choose a renewal window greater than zero days."
        case .unableToLoadSubscriptions:
            return "SubTrack could not load upcoming renewals. Please try again."
        }
    }
}

/// Finds active subscriptions that are expected to renew within a selected number
/// of days, helping the user see which recurring charges are approaching.
struct GetUpcomingRenewalsUseCase {
    let repository: SubscriptionRepository

    /// Returns active renewals from today through the inclusive end of the window,
    /// ordered from the soonest charge to the latest.
    func execute(withinDays days: Int, from now: Date = Date()) throws -> [Subscription] {
        guard days > 0 else {
            throw UpcomingRenewalsError.invalidWindow(days: days)
        }

        let subscriptions: [Subscription]
        do {
            subscriptions = try repository.fetchSubscriptions()
        } catch {
            throw UpcomingRenewalsError.unableToLoadSubscriptions
        }

        let calendar = Calendar.current
        let start = calendar.startOfDay(for: now)
        guard let end = calendar.date(byAdding: .day, value: days, to: start) else {
            throw UpcomingRenewalsError.invalidWindow(days: days)
        }

        return subscriptions
            .filter { subscription in
                guard subscription.isActive else { return false }
                let renewal = calendar.startOfDay(for: subscription.nextRenewalDate)
                return renewal >= start && renewal <= end
            }
            .sorted { $0.nextRenewalDate < $1.nextRenewalDate }
    }
}
