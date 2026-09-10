import Foundation

/// Creates the shared persistence and business-operation dependencies used by the app.
final class DependencyContainer {
    private let subscriptionRepository: SubscriptionRepository

    init(subscriptionRepository: SubscriptionRepository = UserDefaultsSubscriptionRepository()) {
        self.subscriptionRepository = subscriptionRepository
    }

    @MainActor
    func makeDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(
            calculateSpendingUseCase: CalculateRecurringSpendingUseCase(repository: subscriptionRepository),
            upcomingRenewalsUseCase: GetUpcomingRenewalsUseCase(repository: subscriptionRepository)
        )
    }

    @MainActor
    func makeAddSubscriptionViewModel() -> AddSubscriptionViewModel {
        AddSubscriptionViewModel(
            addSubscriptionUseCase: AddSubscriptionUseCase(repository: subscriptionRepository)
        )
    }

    @MainActor
    func makeUpcomingRenewalsViewModel() -> UpcomingRenewalsViewModel {
        UpcomingRenewalsViewModel(
            upcomingRenewalsUseCase: GetUpcomingRenewalsUseCase(repository: subscriptionRepository),
            removeSubscriptionUseCase: RemoveSubscriptionUseCase(repository: subscriptionRepository)
        )
    }

    @MainActor
    func makeSpendingOverviewViewModel() -> SpendingOverviewViewModel {
        SpendingOverviewViewModel(
            calculateSpendingUseCase: CalculateRecurringSpendingUseCase(repository: subscriptionRepository)
        )
    }
}
