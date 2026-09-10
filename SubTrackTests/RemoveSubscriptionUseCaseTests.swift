//
//  RemoveSubscriptionUseCaseTests.swift
//  SubTrack
//
//  Created by Zade Elsaddik on 10/9/2026.
//

import XCTest
@testable import SubTrack

final class RemoveSubscriptionUseCaseTests: XCTestCase {

    func test_removeSubscription_removesExistingSubscription() throws {
        let subscription = Subscription(
            serviceName: "Spotify",
            cost: Decimal(string: "13.99")!,
            billingCycle: .monthly,
            nextRenewalDate: makeTestDate(month: 9, day: 20),
            category: .music
        )

        let repository = TestSubscriptionRepository(
            subscriptions: [subscription]
        )

        let useCase = RemoveSubscriptionUseCase(
            repository: repository
        )

        try useCase.execute(subscriptionID: subscription.id)

        XCTAssertTrue(repository.subscriptions.isEmpty)
    }

    func test_removeSubscription_fails_whenSubscriptionDoesNotExist() {
        let repository = TestSubscriptionRepository()

        let useCase = RemoveSubscriptionUseCase(
            repository: repository
        )

        XCTAssertThrowsError(
            try useCase.execute(subscriptionID: UUID())
        ) { error in
            XCTAssertEqual(
                error as? RemoveSubscriptionError,
                .subscriptionNotFound
            )
        }
    }
}
