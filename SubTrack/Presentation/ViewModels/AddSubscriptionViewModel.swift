import Foundation
import Combine

/// Presentation state for recording a new recurring subscription.
@MainActor
final class AddSubscriptionViewModel: ObservableObject {
    @Published var serviceName = ""
    @Published var costText = ""
    @Published var billingCycle: BillingCycle = .monthly
    @Published var nextRenewalDate: Date
    @Published var category: SubscriptionCategory = .entertainment
    @Published var errorMessage: String?
    @Published private(set) var didSave = false

    private let addSubscriptionUseCase: AddSubscriptionUseCase

    init(addSubscriptionUseCase: AddSubscriptionUseCase) {
        self.addSubscriptionUseCase = addSubscriptionUseCase
        self.nextRenewalDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    }

    func save() {
        guard let cost = parseCost(costText) else {
            errorMessage = AddSubscriptionError.invalidCost.errorDescription
            return
        }

        do {
            try addSubscriptionUseCase.execute(
                serviceName: serviceName,
                cost: cost,
                billingCycle: billingCycle,
                nextRenewalDate: nextRenewalDate,
                category: category
            )
            errorMessage = nil
            didSave = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "SubTrack could not save this subscription. Please try again."
        }
    }

    private func parseCost(_ text: String) -> Decimal? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let localeSeparator = Locale.current.decimalSeparator ?? "."
        var normalised = trimmed.replacingOccurrences(of: "$", with: "")
        normalised = normalised.replacingOccurrences(of: " ", with: "")

        if localeSeparator == "," {
            normalised = normalised.replacingOccurrences(of: ".", with: "")
            normalised = normalised.replacingOccurrences(of: ",", with: ".")
        } else {
            normalised = normalised.replacingOccurrences(of: ",", with: "")
        }

        return Decimal(string: normalised, locale: Locale(identifier: "en_US_POSIX"))
    }
}
