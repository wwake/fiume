import SwiftUI

struct PlanListView: View {
	@Bindable var plan: Plan
	@State var isPresentingSheet = false

	var body: some View {
		List {
			ForEach(plan.contents, id: \.name) { plan in
				Section(header: HStack {
					Text(plan.name)
					Spacer()
					Button(
						" ",
						systemImage: "plus") {
							print("clicked")
						}
				}) {
					OutlineGroup(
						plan.children ?? [],
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
					.sheet(isPresented: $isPresentingSheet) {
						CreateStreamView(plan: plan)
					}
			}
		}
		.padding()
	}
}

#Preview {
	var plan = Plan()
	let stream = Stream("Annuity", Dollar(1000))
	plan.add(stream)
	return PlanListView(plan: plan)
}
