import SwiftUI

struct AddSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddSubscriptionViewModel

    init(viewModel: AddSubscriptionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Subscription") {
                    TextField("Service name", text: $viewModel.serviceName)
                        .textInputAutocapitalization(.words)

                    Picker("Category", selection: $viewModel.category) {
                        ForEach(SubscriptionCategory.allCases) { category in
                            Label(category.displayName, systemImage: category.systemImageName)
                                .tag(category)
                        }
                    }
                }

                Section("Billing") {
                    HStack {
                        Text("Cost")
                        Spacer()
                        TextField("0.00", text: $viewModel.costText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 120)
                    }

                    Picker("Billing Cycle", selection: $viewModel.billingCycle) {
                        ForEach(BillingCycle.allCases) { cycle in
                            Text(cycle.displayName).tag(cycle)
                        }
                    }

                    DatePicker(
                        "Next Renewal",
                        selection: $viewModel.nextRenewalDate,
                        in: Calendar.current.startOfDay(for: Date())...,
                        displayedComponents: .date
                    )
                }

                Section {
                    Label(
                        "SubTrack uses the billing cycle to calculate comparable monthly and annual spending.",
                        systemImage: "info.circle"
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { viewModel.save() }
                        .fontWeight(.semibold)
                }
            }
            .onChange(of: viewModel.didSave) { _, didSave in
                if didSave { dismiss() }
            }
            .alert("Couldn’t Save Subscription", isPresented: errorAlertBinding) {
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
