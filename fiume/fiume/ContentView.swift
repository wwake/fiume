import Charts
import SwiftUI

struct CreateStreamView: View {
	@Environment(\.dismiss) var dismiss

	@Bindable var plan: Plan

	@State private var name = ""
	@State private var amount: Int?
	@State private var startMonth: Int?
	@State private var endMonth: Int?

	private static let formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		return formatter
	}()

	var body: some View {
		Form {
			LabeledContent {
				TextField("Name", text: $name)
			} label: {
				Text("Name")
			}
			
			LabeledContent {
				TextField("Amount", value: $amount, format: .number)
					.keyboardType(.decimalPad)
			} label: {
				Text("Amount")
			}
			
			LabeledContent {
				TextField("Start Month", value: $startMonth, format: .number)
					.keyboardType(.decimalPad)
			} label: {
				Text("Start Month")
			}

			LabeledContent {
				TextField("End Month", value: $endMonth, format: .number)
					.keyboardType(.decimalPad)
			} label: {
				Text("End Month")
			}

			Button("Create") {
				plan.add(Stream(
					name,
					Dollar(amount ?? 0),
					first: startMonth ?? 1,
					last: endMonth))
				dismiss()
			}
		}
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
