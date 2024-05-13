import Charts
import SwiftUI

struct NumberField: View {
	var label: String
	@Binding var value: Int?

	var body: some View {
		LabeledContent {
			TextField(label, value: $value, format: .number)
				.keyboardType(.decimalPad)
		} label: {
			Text(label)
		}
	}
}

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
			
			NumberField(label: "Amount", value: $amount)

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

struct ContentView: View {
	@Bindable var plan: Plan
	@State var isPresentingSheet = false

    var body: some View {
		NavigationStack {
			Chart(plan.project(120)) {
				LineMark(
				x: .value("Month", $0.month),
				y: .value("Net Worth", $0.amount)
				)
			}
			.padding()

			List {
				ForEach(plan.streams.reversed()) {
					Text("\($0.name) \($0.monthlyAmount)")
						.listRowBackground($0.monthlyAmount < 0 ? Color.red : Color.green)
				}
				.onMove { indexSet, offset in
					plan.streams.move(fromOffsets: indexSet, toOffset: offset)
				}
				.onDelete { offsets in
					plan.streams.remove(atOffsets: offsets)
				}
			}
			.toolbar {
				ToolbarItemGroup {
					Button(
						"Add",
						systemImage: "plus") {
							isPresentingSheet.toggle()
					}
						.sheet(isPresented: $isPresentingSheet) {
							CreateStreamView(plan: plan)
						}
					EditButton()
				}
			}
			.padding()
		}
    }
}

#Preview {
	let plan = Plan()
	plan.add(Stream("Salary", 1_000, last: 60))
	plan.add(Stream("Expenses", -800))
	return ContentView(plan: plan)
}
