import XCTest
@testable import SubTrack

final class CalculateRecurringSpendingUseCaseTests: XCTestCase {
    func test_calculateRecurringSpending_normalisesDifferentBillingCycles() throws {
        let repository = TestSubscriptionRepository(subscriptions: [
            Subscription(
                serviceName: "Monthly Service",
                cost: 12,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 10, day: 1),
                category: .entertainment
            ),
            Subscription(
                serviceName: "Yearly Service",
                cost: 120,
                billingCycle: .yearly,
                nextRenewalDate: makeTestDate(month: 10, day: 1),
                category: .productivity
            ),
            Subscription(
                serviceName: "Weekly Service",
                cost: 15,
                billingCycle: .weekly,
                nextRenewalDate: makeTestDate(month: 10, day: 1),
                category: .education
            )
        ])
        let useCase = CalculateRecurringSpendingUseCase(repository: repository)

        let summary = try useCase.execute()

        XCTAssertEqual(summary.monthlyEquivalent, 87) // 12 + 10 + (15*52/12 = 65)
        XCTAssertEqual(summary.annualEquivalent, 1044)
        XCTAssertEqual(summary.activeSubscriptionCount, 3)
    }

    func test_calculateRecurringSpending_excludesInactiveSubscriptions() throws {
        let repository = TestSubscriptionRepository(subscriptions: [
            Subscription(
                serviceName: "Active",
                cost: 20,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 10, day: 1),
                category: .other,
                status: .active
            ),
            Subscription(
                serviceName: "Inactive",
                cost: 99,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 10, day: 1),
                category: .other,
                status: .inactive
            )
        ])
        let useCase = CalculateRecurringSpendingUseCase(repository: repository)

        let summary = try useCase.execute()

        XCTAssertEqual(summary.monthlyEquivalent, 20)
        XCTAssertEqual(summary.activeSubscriptionCount, 1)
    }

    func test_calculateRecurringSpending_fails_whenStoredActiveCostIsInvalid() {
        let repository = TestSubscriptionRepository(subscriptions: [
            Subscription(
                serviceName: "Broken Record",
                cost: 0,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 10, day: 1),
                category: .other
            )
        ])
        let useCase = CalculateRecurringSpendingUseCase(repository: repository)

        XCTAssertThrowsError(try useCase.execute()) { error in
            XCTAssertEqual(
                error as? RecurringSpendingError,
                .invalidStoredCost(serviceName: "Broken Record")
            )
        }
    }
}
