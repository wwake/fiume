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
let plan = Possibilities()
  let stream = Stream("Annuity", Money(1_000), first: .month(1), last: .unspecified)
	plan.add(stream)
	return PlanListView(plan: plan)
}
