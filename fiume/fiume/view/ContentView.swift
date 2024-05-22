import Charts
import SwiftUI

struct ContentView: View {
	@Bindable var possibilities: Possibilities

	var body: some View {
		NavigationStack {
      Chart(possibilities.project(120)[0].data) {
				LineMark(
					x: .value("Month", $0.month),
					y: .value("Net Worth", $0.amount)
				)
			}
			.padding()

			PlanListView(plan: possibilities)
		}
	}
}

#Preview {
	let possibilities = Possibilities()
	possibilities.add(Stream("Salary", 1_000, last: 60))
	possibilities.add(Stream("Expenses", -800))
	return ContentView(possibilities: possibilities)
}
