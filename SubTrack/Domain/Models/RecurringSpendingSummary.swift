import Foundation

/// A personal-finance summary of the user's active recurring subscription commitments.
struct RecurringSpendingSummary: Equatable {
    let monthlyEquivalent: Decimal
    let annualEquivalent: Decimal
    let activeSubscriptionCount: Int
    let monthlyTotalsByCategory: [SubscriptionCategory: Decimal]

    static let empty = RecurringSpendingSummary(
        monthlyEquivalent: .zero,
        annualEquivalent: .zero,
        activeSubscriptionCount: 0,
        monthlyTotalsByCategory: [:]
    )
}
