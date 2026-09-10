import Foundation

#if DEBUG
enum PreviewData {
    static let subscriptions: [Subscription] = [
        Subscription(
            serviceName: "Spotify",
            cost: Decimal(string: "13.99")!,
            billingCycle: .monthly,
            nextRenewalDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            category: .music
        ),
        Subscription(
            serviceName: "Netflix",
            cost: Decimal(string: "18.99")!,
            billingCycle: .monthly,
            nextRenewalDate: Calendar.current.date(byAdding: .day, value: 9, to: Date())!,
            category: .entertainment
        ),
        Subscription(
            serviceName: "iCloud+",
            cost: Decimal(string: "4.49")!,
            billingCycle: .monthly,
            nextRenewalDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
            category: .cloudStorage
        )
    ]
}
#endif
