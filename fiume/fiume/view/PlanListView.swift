import SwiftUI

struct AddPlanView: View {
	@Bindable var plan: PlanComposite

	var body: some View {
		CreateStreamView(plan: plan)
	}
}

struct PlanListView: View {
	@Bindable var plan: Plan
	@State var isPresentingSheet = false
	@State var isPresentingAddView = false

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
		.toolbar {
			ToolbarItemGroup {
				Button(
					"Add",
					systemImage: "plus") {
						isPresentingSheet.toggle()
					}
//					.sheet(isPresented: $isPresentingSheet) {
//						CreateStreamView(plan: plan)
//					}
			}
		}
		.padding()
	}
}

#Preview {
let plan = Plan()
	let stream = Stream("Annuity", Money(1000))
	plan.add(stream)
	return PlanListView(plan: plan)
}
