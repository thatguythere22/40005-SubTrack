import Foundation

/// A recurring paid service that the user wants to monitor in SubTrack.
///
/// Business Rules:
/// - An active subscription contributes to recurring spending totals.
/// - The recorded cost must be greater than zero before a subscription is saved.
/// - The next renewal date cannot be earlier than the day it is recorded.
/// - Different billing cycles are normalised before costs are compared.
struct Subscription: Identifiable, Codable, Equatable, RecurringFinancialCommitment {
    let id: UUID
    var serviceName: String
    var cost: Decimal
    var billingCycle: BillingCycle
    var nextRenewalDate: Date
    var category: SubscriptionCategory
    var status: SubscriptionStatus

    init(
        id: UUID = UUID(),
        serviceName: String,
        cost: Decimal,
        billingCycle: BillingCycle,
        nextRenewalDate: Date,
        category: SubscriptionCategory,
        status: SubscriptionStatus = .active
    ) {
        self.id = id
        self.serviceName = serviceName
        self.cost = cost
        self.billingCycle = billingCycle
        self.nextRenewalDate = nextRenewalDate
        self.category = category
        self.status = status
    }

    var isActive: Bool {
        status == .active
    }

    func monthlyEquivalentCost() -> Decimal {
        billingCycle.monthlyEquivalent(for: cost)
    }

    func annualEquivalentCost() -> Decimal {
        billingCycle.annualEquivalent(for: cost)
    }
}
