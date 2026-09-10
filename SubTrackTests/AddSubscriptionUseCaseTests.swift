import XCTest
@testable import SubTrack

final class AddSubscriptionUseCaseTests: XCTestCase {
    func test_addSubscription_savesValidRecurringSubscription() throws {
        let repository = TestSubscriptionRepository()
        let useCase = AddSubscriptionUseCase(repository: repository)
        let now = makeTestDate(month: 9, day: 9)

        let saved = try useCase.execute(
            serviceName: "Spotify",
            cost: Decimal(string: "13.99")!,
            billingCycle: .monthly,
            nextRenewalDate: makeTestDate(month: 9, day: 14),
            category: .music,
            now: now
        )

        XCTAssertEqual(saved.serviceName, "Spotify")
        XCTAssertEqual(repository.subscriptions.count, 1)
        XCTAssertEqual(repository.subscriptions.first, saved)
    }

    func test_addSubscription_fails_whenServiceNameIsBlank() {
        let repository = TestSubscriptionRepository()
        let useCase = AddSubscriptionUseCase(repository: repository)

        XCTAssertThrowsError(
            try useCase.execute(
                serviceName: "   ",
                cost: 10,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 9, day: 14),
                category: .other,
                now: makeTestDate(month: 9, day: 9)
            )
        ) { error in
            XCTAssertEqual(error as? AddSubscriptionError, .missingServiceName)
        }
    }

    func test_addSubscription_fails_whenCostIsZero() {
        let repository = TestSubscriptionRepository()
        let useCase = AddSubscriptionUseCase(repository: repository)

        XCTAssertThrowsError(
            try useCase.execute(
                serviceName: "Cloud Service",
                cost: 0,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 9, day: 14),
                category: .cloudStorage,
                now: makeTestDate(month: 9, day: 9)
            )
        ) { error in
            XCTAssertEqual(error as? AddSubscriptionError, .invalidCost)
        }
    }

    func test_addSubscription_fails_whenRenewalDateIsInPast() {
        let repository = TestSubscriptionRepository()
        let useCase = AddSubscriptionUseCase(repository: repository)

        XCTAssertThrowsError(
            try useCase.execute(
                serviceName: "Netflix",
                cost: 18.99,
                billingCycle: .monthly,
                nextRenewalDate: makeTestDate(month: 9, day: 8),
                category: .entertainment,
                now: makeTestDate(month: 9, day: 9)
            )
        ) { error in
            XCTAssertEqual(error as? AddSubscriptionError, .invalidRenewalDate)
        }
    }
}
