import Foundation
import Combine

/// Presentation state for the subscription dashboard.
@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var spendingSummary: RecurringSpendingSummary = .empty
    @Published private(set) var upcomingRenewals: [Subscription] = []
    @Published var errorMessage: String?

    private let calculateSpendingUseCase: CalculateRecurringSpendingUseCase
    private let upcomingRenewalsUseCase: GetUpcomingRenewalsUseCase

    init(
        calculateSpendingUseCase: CalculateRecurringSpendingUseCase,
        upcomingRenewalsUseCase: GetUpcomingRenewalsUseCase
    ) {
        self.calculateSpendingUseCase = calculateSpendingUseCase
        self.upcomingRenewalsUseCase = upcomingRenewalsUseCase
    }

    func refresh() {
        do {
            spendingSummary = try calculateSpendingUseCase.execute()
            upcomingRenewals = try upcomingRenewalsUseCase.execute(withinDays: 30)
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "SubTrack could not refresh your subscription overview. Please try again."
        }
    }
}
