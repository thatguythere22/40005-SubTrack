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

    init(upcomingRenewalsUseCase: GetUpcomingRenewalsUseCase) {
        self.upcomingRenewalsUseCase = upcomingRenewalsUseCase
    }

    func refresh() {
        do {
            renewals = try upcomingRenewalsUseCase.execute(withinDays: selectedWindow)
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "SubTrack could not load upcoming renewals. Please try again."
        }
    }
}
