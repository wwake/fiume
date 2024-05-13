import Charts
import SwiftUI

struct ContentView: View {
	@Bindable var plan: Plan
	@State var isEditing = false

    var body: some View {
		VStack {
			Chart(plan.project(120)) {
				LineMark(
				x: .value("Month", $0.month),
				y: .value("Net Worth", $0.amount)
				)
			}
			.padding()

			List(plan.streams.reversed()) {
				Text("\($0.name) \($0.monthlyAmount)")
					.listRowBackground($0.monthlyAmount < 0 ? Color.red : Color.green)
			}
			.toolbar {
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
