import Foundation
import Combine

/// Presentation state for the user's recurring subscription spending overview.
@MainActor
final class SpendingOverviewViewModel: ObservableObject {
    struct CategorySpendingRow: Identifiable {
        let category: SubscriptionCategory
        let monthlyAmount: Decimal
        var id: String { category.rawValue }
    }

    @Published private(set) var summary: RecurringSpendingSummary = .empty
    @Published var errorMessage: String?

    private let calculateSpendingUseCase: CalculateRecurringSpendingUseCase

    init(calculateSpendingUseCase: CalculateRecurringSpendingUseCase) {
        self.calculateSpendingUseCase = calculateSpendingUseCase
    }

    var categoryRows: [CategorySpendingRow] {
        summary.monthlyTotalsByCategory
            .map { CategorySpendingRow(category: $0.key, monthlyAmount: $0.value) }
            .sorted { $0.monthlyAmount > $1.monthlyAmount }
    }

    func refresh() {
        do {
            summary = try calculateSpendingUseCase.execute()
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "SubTrack could not calculate your recurring spending. Please try again."
        }
    }
}
