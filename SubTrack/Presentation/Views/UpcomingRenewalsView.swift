import SwiftUI

struct UpcomingRenewalsView: View {
    @StateObject private var viewModel: UpcomingRenewalsViewModel

    init(viewModel: UpcomingRenewalsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Renewal Window", selection: $viewModel.selectedWindow) {
                    ForEach(viewModel.availableWindows, id: \.self) { days in
                        Text("\(days) Days").tag(days)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)

                if viewModel.renewals.isEmpty {
                    Spacer()
                    EmptyStateView(
                        title: "No renewals in this window",
                        message: "Try a longer period or add a subscription with an upcoming billing date.",
                        systemImage: "calendar.badge.checkmark"
                    )
                    .padding(.horizontal, 18)
                    Spacer()
                } else {
                    List(viewModel.renewals) { subscription in
                        SubscriptionRow(subscription: subscription, showDaysUntilRenewal: true)
                            .listRowBackground(Color(.secondarySystemBackground))
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Upcoming")
            .onAppear(perform: viewModel.refresh)
            .onChange(of: viewModel.selectedWindow) { _, _ in
                viewModel.refresh()
            }
            .alert("Unable to Load Renewals", isPresented: errorAlertBinding) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
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
