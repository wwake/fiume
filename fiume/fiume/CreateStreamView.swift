import SwiftUI

struct CreateStreamView: View {
	@Environment(\.dismiss) var dismiss

	@Bindable var plan: Plan

	@State private var name = ""
	@State private var amount: Int?
	@State private var startMonth: Int?
	@State private var endMonth: Int?

	var body: some View {
		Form {
			LabeledContent {
				TextField("Name", text: $name)
			} label: {
				Text("Name")
			}

			NumberField(label: "Amount $", value: $amount)

			NumberField(label: "Start Month", value: $startMonth)

			NumberField(label: "End Month", value: $endMonth)

			Button("Create") {
				plan.add(Stream(
					name,
					Dollar(amount ?? 0),
					first: startMonth ?? 1,
					last: endMonth))
				dismiss()
			}
		}
		.autocorrectionDisabled()
	}
}
