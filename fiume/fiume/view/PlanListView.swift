import SwiftUI

struct PlanListView: View {
	@Bindable var plan: MultiScenarioPlan

	var body: some View {
		List {
			ForEach(plan.sections, id: \.name) { planTree in
				Section(header: PlanTreeView(plan: planTree)
				) {
					OutlineGroup(
						planTree.children ?? [],
						id: \.name,
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
let plan = MultiScenarioPlan()
	let stream = Stream("Annuity", Money(1000))
	plan.add(stream)
	return PlanListView(plan: plan)
}
