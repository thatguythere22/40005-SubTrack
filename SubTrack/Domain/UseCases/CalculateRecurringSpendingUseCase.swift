import Foundation

/// Errors that prevent SubTrack from presenting a trustworthy recurring-spending summary.
enum RecurringSpendingError: LocalizedError, Equatable {
    case invalidStoredCost(serviceName: String)
    case unableToLoadSubscriptions

    var errorDescription: String? {
        switch self {
        case .invalidStoredCost(let serviceName):
            return "The recorded cost for \(serviceName) is invalid. Edit that subscription before relying on the spending total."
        case .unableToLoadSubscriptions:
            return "SubTrack could not load your subscriptions. Please try again."
        }
    }
}

/// Calculates the user's active recurring financial commitment by normalising
/// weekly, monthly, quarterly and yearly subscriptions into comparable totals.
struct CalculateRecurringSpendingUseCase {
    let repository: SubscriptionRepository

    /// Returns monthly and annual equivalents plus a category breakdown.
    func execute() throws -> RecurringSpendingSummary {
        let subscriptions: [Subscription]

        do {
            subscriptions = try repository.fetchSubscriptions()
        } catch {
            throw RecurringSpendingError.unableToLoadSubscriptions
        }

        let activeSubscriptions = subscriptions.filter(\.isActive)
        var monthlyTotal = Decimal.zero
        var annualTotal = Decimal.zero
        var categoryTotals: [SubscriptionCategory: Decimal] = [:]

        for subscription in activeSubscriptions {
            guard subscription.cost > .zero else {
                throw RecurringSpendingError.invalidStoredCost(serviceName: subscription.serviceName)
            }

            let monthlyEquivalent = subscription.monthlyEquivalentCost()
            monthlyTotal += monthlyEquivalent
            annualTotal += subscription.annualEquivalentCost()
            categoryTotals[subscription.category, default: .zero] += monthlyEquivalent
        }

        return RecurringSpendingSummary(
            monthlyEquivalent: monthlyTotal,
            annualEquivalent: annualTotal,
            activeSubscriptionCount: activeSubscriptions.count,
            monthlyTotalsByCategory: categoryTotals
        )
    }
}
