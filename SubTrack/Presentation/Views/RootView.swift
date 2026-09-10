import SwiftUI

struct RootView: View {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    var body: some View {
        TabView {
            DashboardView(
                viewModel: container.makeDashboardViewModel(),
                makeAddSubscriptionViewModel: { container.makeAddSubscriptionViewModel() }
            )
            .tabItem {
                Label("Home", systemImage: "house")
            }

            UpcomingRenewalsView(viewModel: container.makeUpcomingRenewalsViewModel())
                .tabItem {
                    Label("Upcoming", systemImage: "calendar")
                }

            SpendingOverviewView(viewModel: container.makeSpendingOverviewViewModel())
                .tabItem {
                    Label("Spending", systemImage: "chart.pie")
                }
        }
        .tint(.indigo)
    }
}
