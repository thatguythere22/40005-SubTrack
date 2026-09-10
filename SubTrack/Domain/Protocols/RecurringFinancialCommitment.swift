import Foundation

/// A recurring financial commitment that can be compared across billing cycles.
///
/// This protocol models a real personal-finance behaviour: any recurring charge
/// should be expressible as a monthly and annual equivalent before it is included
/// in a spending overview.
protocol RecurringFinancialCommitment {
    var cost: Decimal { get }
    var billingCycle: BillingCycle { get }

    func monthlyEquivalentCost() -> Decimal
    func annualEquivalentCost() -> Decimal
}
