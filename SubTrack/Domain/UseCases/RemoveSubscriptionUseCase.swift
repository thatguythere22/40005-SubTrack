//
//  RemoveSubscriptionUseCase.swift
//  SubTrack
//
//  Created by Zade Elsaddik on 10/9/2026.
//

import Foundation

/// Errors that can prevent a subscription from being removed from SubTrack.
enum RemoveSubscriptionError: LocalizedError, Equatable {
    case subscriptionNotFound
    case unableToRemove

    var errorDescription: String? {
        switch self {
        case .subscriptionNotFound:
            return "This subscription could not be found in SubTrack. Refresh and try again."
        case .unableToRemove:
            return "SubTrack could not remove this subscription. Please try again."
        }
    }
}

/// Removes a subscription record from the user's SubTrack tracker.
///
/// Removing a record from SubTrack does not cancel the real subscription
/// with the subscription provider.
struct RemoveSubscriptionUseCase {
    let repository: SubscriptionRepository

    func execute(subscriptionID: UUID) throws {
        let subscriptions: [Subscription]

        do {
            subscriptions = try repository.fetchSubscriptions()
        } catch {
            throw RemoveSubscriptionError.unableToRemove
        }

        guard subscriptions.contains(where: { $0.id == subscriptionID }) else {
            throw RemoveSubscriptionError.subscriptionNotFound
        }

        let remainingSubscriptions = subscriptions.filter {
            $0.id != subscriptionID
        }

        do {
            try repository.replaceAll(remainingSubscriptions)
        } catch {
            throw RemoveSubscriptionError.unableToRemove
        }
    }
}
