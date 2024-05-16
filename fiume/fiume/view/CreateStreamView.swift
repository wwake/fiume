import SwiftUI

struct CreateStreamView: View {
	@Environment(\.dismiss) var dismiss

	@Bindable var plan: PlanComposite

	@State private var name = ""
	@State private var amount: Int?
	@State private var startMonth: Int?
	@State private var endMonth: Int?

	var body: some View {
		Text("Create a New Stream").font(.title)

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
				let stream = Stream(
					name,
					Money(amount ?? 0),
					first: startMonth ?? 1,
					last: endMonth)
				plan.append(PlanLeaf(stream))
				dismiss()
			}
		}
		.autocorrectionDisabled()
	}
}
