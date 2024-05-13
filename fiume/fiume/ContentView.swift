import Charts
import SwiftUI

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
					StreamView(stream: $0)
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

struct StreamView: View {
	var stream: Stream

	var body: some View {
		Text("\(stream.name) \(stream.monthlyAmount)")
			.listRowBackground(stream.monthlyAmount < 0 ? Color.red : Color.green)
	}
}
