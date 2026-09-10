import SwiftUI

struct SubscriptionRow: View {
    let subscription: Subscription
    var showDaysUntilRenewal = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: subscription.category.systemImageName)
                .font(.system(size: 17, weight: .semibold))
                .frame(width: 42, height: 42)
                .background(Color.accentColor.opacity(0.12))
                .foregroundStyle(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.serviceName)
                    .font(.body.weight(.semibold))

                HStack(spacing: 5) {
                    Text(DateDisplayFormatter.full(subscription.nextRenewalDate))
                    if showDaysUntilRenewal {
                        Text("•")
                        Text(daysUntilRenewalText)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(MoneyDisplayFormatter.string(from: subscription.cost))
                    .font(.body.weight(.semibold))
                Text(subscription.billingCycle.displayName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 5)
    }

    private var daysUntilRenewalText: String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let renewal = calendar.startOfDay(for: subscription.nextRenewalDate)
        let days = calendar.dateComponents([.day], from: today, to: renewal).day ?? 0

        switch days {
        case 0: return "Today"
        case 1: return "Tomorrow"
        default: return "In \(days) days"
        }
    }
}
