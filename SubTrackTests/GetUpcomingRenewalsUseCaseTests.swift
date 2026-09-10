import XCTest
@testable import SubTrack

final class GetUpcomingRenewalsUseCaseTests: XCTestCase {
    func test_getUpcomingRenewals_returnsOnlyActiveRenewalsInsideWindow_inDateOrder() throws {
        let now = makeTestDate(month: 9, day: 9)
        let repository = TestSubscriptionRepository(subscriptions: [
            Subscription(
                serviceName: "Later",
                cost: 20,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 9, day: 20),
                category: .other
            ),
            Subscription(
                serviceName: "Sooner",
                cost: 10,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 9, day: 12),
                category: .music
            ),
            Subscription(
                serviceName: "Outside Window",
                cost: 30,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 11, day: 1),
                category: .productivity
            ),
            Subscription(
                serviceName: "Inactive",
                cost: 40,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 9, day: 11),
                category: .gaming,
                status: .inactive
            )
        ])
        let useCase = GetUpcomingRenewalsUseCase(repository: repository)

        let renewals = try useCase.execute(withinDays: 30, from: now)

        XCTAssertEqual(renewals.map(\.serviceName), ["Sooner", "Later"])
    }

    func test_getUpcomingRenewals_includesRenewalOnWindowBoundary() throws {
        let now = makeTestDate(month: 9, day: 9)
        let repository = TestSubscriptionRepository(subscriptions: [
            Subscription(
                serviceName: "Boundary Service",
                cost: 10,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 10, day: 9),
                category: .other
            )
        ])
        let useCase = GetUpcomingRenewalsUseCase(repository: repository)

        let renewals = try useCase.execute(withinDays: 30, from: now)

        XCTAssertEqual(renewals.count, 1)
        XCTAssertEqual(renewals.first?.serviceName, "Boundary Service")
    }

    func test_getUpcomingRenewals_fails_whenWindowIsNotPositive() {
        let repository = TestSubscriptionRepository()
        let useCase = GetUpcomingRenewalsUseCase(repository: repository)

        XCTAssertThrowsError(try useCase.execute(withinDays: 0)) { error in
            XCTAssertEqual(error as? UpcomingRenewalsError, .invalidWindow(days: 0))
        }
    }
}
