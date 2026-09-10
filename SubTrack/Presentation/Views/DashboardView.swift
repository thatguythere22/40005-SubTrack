import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @State private var showingAddSubscription = false

    private let makeAddSubscriptionViewModel: @MainActor () -> AddSubscriptionViewModel

    init(
        viewModel: DashboardViewModel,
        makeAddSubscriptionViewModel: @escaping @MainActor () -> AddSubscriptionViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.makeAddSubscriptionViewModel = makeAddSubscriptionViewModel
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    welcomeHeader

                    MetricCard(
                        title: "Monthly Equivalent",
                        value: MoneyDisplayFormatter.string(from: viewModel.spendingSummary.monthlyEquivalent),
                        subtitle: "Average recurring subscription commitment",
                        systemImage: "dollarsign.circle"
                    )

                    HStack(spacing: 12) {
                        compactMetric(
                            title: "Annual",
                            value: MoneyDisplayFormatter.string(from: viewModel.spendingSummary.annualEquivalent),
                            systemImage: "calendar"
                        )

                        compactMetric(
                            title: "Active",
                            value: "\(viewModel.spendingSummary.activeSubscriptionCount)",
                            systemImage: "checkmark.circle"
                        )
                    }

                    upcomingSection
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("SubTrack")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSubscription = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                    .accessibilityLabel("Add Subscription")
                }
            }
            .sheet(isPresented: $showingAddSubscription, onDismiss: viewModel.refresh) {
                AddSubscriptionView(viewModel: makeAddSubscriptionViewModel())
            }
            .onAppear(perform: viewModel.refresh)
            .alert("Unable to Refresh", isPresented: errorAlertBinding) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private var welcomeHeader: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Your recurring spending")
                .font(.title2.bold())
            Text("See what you pay, what renews next, and what it adds up to.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 6)
    }

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Upcoming Renewals")
                    .font(.headline)
                Spacer()
                Text("30 days")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            if viewModel.upcomingRenewals.isEmpty {
                EmptyStateView(
                    title: "Nothing due soon",
                    message: "Add a subscription and its next renewal will appear here.",
                    systemImage: "calendar.badge.checkmark"
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.upcomingRenewals.prefix(4).enumerated()), id: \.element.id) { index, subscription in
                        SubscriptionRow(subscription: subscription, showDaysUntilRenewal: true)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)

                        if index < min(viewModel.upcomingRenewals.count, 4) - 1 {
                            Divider().padding(.leading, 72)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
            }
        }
    }

    private func compactMetric(title: String, value: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(Color.accentColor)
            Text(value)
                .font(.headline)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var errorAlertBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented { viewModel.errorMessage = nil }
            }
        )
    }
}
