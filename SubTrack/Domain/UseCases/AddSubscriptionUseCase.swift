import Foundation

/// Errors that can prevent a recurring subscription from being recorded accurately.
enum AddSubscriptionError: LocalizedError, Equatable {
    case missingServiceName
    case invalidCost
    case invalidRenewalDate
    case unableToSave

    var errorDescription: String? {
        switch self {
        case .missingServiceName:
            return "Enter the subscription service name before saving."
        case .invalidCost:
            return "Subscription cost must be greater than $0. Check the amount and try again."
        case .invalidRenewalDate:
            return "The next renewal date cannot be in the past. Check the billing date and try again."
        case .unableToSave:
            return "SubTrack could not save this subscription. Please try again."
        }
    }
}

/// Records a new recurring subscription after protecting the user's financial data
/// with the rules required for a valid subscription record.
struct AddSubscriptionUseCase {
    let repository: SubscriptionRepository

    /// Creates and stores a valid subscription record.
    ///
    /// - Parameters:
    ///   - serviceName: Provider or service name shown to the user.
    ///   - cost: Amount charged once per selected billing cycle.
    ///   - billingCycle: Frequency of the recurring charge.
    ///   - nextRenewalDate: Next date on which the subscription is expected to renew.
    ///   - category: Personal-finance category used in spending summaries.
    ///   - now: Current date. Injectable so the business rule can be unit tested.
    @discardableResult
    func execute(
        serviceName: String,
        cost: Decimal,
        billingCycle: BillingCycle,
        nextRenewalDate: Date,
        category: SubscriptionCategory,
        now: Date = Date()
    ) throws -> Subscription {
        let cleanedName = serviceName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedName.isEmpty else {
            throw AddSubscriptionError.missingServiceName
        }

        guard cost > .zero else {
            throw AddSubscriptionError.invalidCost
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        let renewalDay = calendar.startOfDay(for: nextRenewalDate)

        guard renewalDay >= today else {
            throw AddSubscriptionError.invalidRenewalDate
        }

        let subscription = Subscription(
            serviceName: cleanedName,
            cost: cost,
            billingCycle: billingCycle,
            nextRenewalDate: nextRenewalDate,
            category: category
        )

        do {
            try repository.save(subscription)
            return subscription
        } catch {
            throw AddSubscriptionError.unableToSave
        }
    }
}
