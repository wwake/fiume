import SwiftUI

struct PlanListView: View {
	@Bindable var plan: Possibilities

	var body: some View {
		List {
			ForEach(plan.sections, id: \.name) { planTree in
				Section(header: PlanTreeView(plan: planTree)) {
					OutlineGroup(
						planTree.children ?? [],
						id: \.id,
						children: \.children
					) { tree in
						PlanTreeView(plan: tree)
					}
				}
			}
		}
		.listStyle(.grouped)
		.padding()
	}
}

#Preview {
  let plan = Possibilities(startDate: MonthYear(date: Date()))
  let stream = Stream("Annuity", Money(1_000), first: .month(2020.jan), last: .unchanged)
	plan.add(stream)
  let people = People()

	return PlanListView(plan: plan)
    .environment(people)
}
