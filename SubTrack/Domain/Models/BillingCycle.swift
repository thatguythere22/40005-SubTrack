import Foundation

/// The frequency at which a subscription provider charges the customer.
///
/// Business Rule: SubTrack normalises every billing cycle into monthly and annual
/// equivalents so subscriptions with different frequencies can be compared fairly.
enum BillingCycle: String, Codable, CaseIterable, Identifiable {
    case weekly
    case monthly
    case quarterly
    case yearly

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .quarterly: return "Quarterly"
        case .yearly: return "Yearly"
        }
    }

    /// Converts one charge into its equivalent average monthly commitment.
    func monthlyEquivalent(for cost: Decimal) -> Decimal {
        switch self {
        case .weekly:
            return (cost * Decimal(52)) / Decimal(12)
        case .monthly:
            return cost
        case .quarterly:
            return cost / Decimal(3)
        case .yearly:
            return cost / Decimal(12)
        }
    }

    /// Converts one charge into its equivalent annual commitment.
    func annualEquivalent(for cost: Decimal) -> Decimal {
        switch self {
        case .weekly:
            return cost * Decimal(52)
        case .monthly:
            return cost * Decimal(12)
        case .quarterly:
            return cost * Decimal(4)
        case .yearly:
            return cost
        }
    }
}
