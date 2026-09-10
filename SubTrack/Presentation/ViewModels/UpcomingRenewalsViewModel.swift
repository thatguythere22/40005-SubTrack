import Foundation
import Combine

/// Presentation state for upcoming subscription renewals.
@MainActor
final class UpcomingRenewalsViewModel: ObservableObject {
    @Published var selectedWindow = 30
    @Published private(set) var renewals: [Subscription] = []
    @Published var errorMessage: String?

    let availableWindows = [7, 30, 90]

    private let upcomingRenewalsUseCase: GetUpcomingRenewalsUseCase
    private let removeSubscriptionUseCase: RemoveSubscriptionUseCase

    init(
        upcomingRenewalsUseCase: GetUpcomingRenewalsUseCase,
        removeSubscriptionUseCase: RemoveSubscriptionUseCase
    ) {
        self.upcomingRenewalsUseCase = upcomingRenewalsUseCase
        self.removeSubscriptionUseCase = removeSubscriptionUseCase
    }

    func refresh() {
        do {
            renewals = try upcomingRenewalsUseCase.execute(withinDays: selectedWindow)
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? "SubTrack could not load upcoming renewals. Please try again."
        }
    }

    func removeSubscriptions(at offsets: IndexSet) {
        let subscriptionsToRemove = offsets.map {
            renewals[$0]
        }

        do {
            for subscription in subscriptionsToRemove {
                try removeSubscriptionUseCase.execute(
                    subscriptionID: subscription.id
                )
            }

            refresh()
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? "SubTrack could not remove this subscription. Please try again."
        }
    }
}
