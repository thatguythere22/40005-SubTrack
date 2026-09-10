import SwiftUI

struct SpendingOverviewView: View {
    @StateObject private var viewModel: SpendingOverviewViewModel

    init(viewModel: SpendingOverviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MetricCard(
                        title: "Monthly Equivalent",
                        value: MoneyDisplayFormatter.string(from: viewModel.summary.monthlyEquivalent),
                        subtitle: "Normalised across all active billing cycles",
                        systemImage: "chart.pie"
                    )

                    HStack(spacing: 12) {
                        summaryTile(
                            title: "Annual Commitment",
                            value: MoneyDisplayFormatter.string(from: viewModel.summary.annualEquivalent)
                        )
                        summaryTile(
                            title: "Active Services",
                            value: "\(viewModel.summary.activeSubscriptionCount)"
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("By Category")
                            .font(.headline)

                        if viewModel.categoryRows.isEmpty {
                            EmptyStateView(
                                title: "No spending to summarise",
                                message: "Add an active subscription to see where your recurring money goes.",
                                systemImage: "chart.bar"
                            )
                        } else {
                            VStack(spacing: 0) {
                                ForEach(Array(viewModel.categoryRows.enumerated()), id: \.element.id) { index, row in
                                    HStack(spacing: 12) {
                                        Image(systemName: row.category.systemImageName)
                                            .frame(width: 34, height: 34)
                                            .background(Color.accentColor.opacity(0.1))
                                            .foregroundStyle(Color.accentColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                                        Text(row.category.displayName)
                                            .font(.subheadline.weight(.medium))

                                        Spacer()

                                        Text(MoneyDisplayFormatter.string(from: row.monthlyAmount))
                                            .font(.subheadline.weight(.semibold))
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 13)

                                    if index < viewModel.categoryRows.count - 1 {
                                        Divider().padding(.leading, 62)
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
                .padding(18)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Spending")
            .onAppear(perform: viewModel.refresh)
            .alert("Unable to Calculate Spending", isPresented: errorAlertBinding) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    private func summaryTile(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
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
