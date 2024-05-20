import Charts
import SwiftUI

struct ContentView: View {
	@Bindable var plan: MultiScenarioPlan

	var body: some View {
		NavigationStack {
			Chart(plan.project(120)) {
				LineMark(
					x: .value("Month", $0.month),
					y: .value("Net Worth", $0.amount)
				)
			}
			.padding()

			PlanListView(plan: plan)
		}
	}
}

#Preview {
	let plan = MultiScenarioPlan()
	plan.add(Stream("Salary", 1_000, last: 60))
	plan.add(Stream("Expenses", -800))
	return ContentView(plan: plan)
}
