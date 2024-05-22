import SwiftUI

struct PlanTreeView: View {
	var plan: PlanTree

	var body: some View {
		if plan is PlanLeaf {
			PlanLeafView(plan: plan as! PlanLeaf)
		} else {
			PlanCompositeView(plan: plan as! PlanComposite)
		}
	}
}

struct PlanLeafView: View {
	var plan: PlanLeaf

	var body: some View {
		StreamView(stream: plan.stream)
	}
}

struct PlanCompositeView: View {
	var plan: PlanComposite
	@State private var isAddPresented = false

	var body: some View {
		HStack {
			Text(plan.name)
			Spacer()
			Button(
				" ",
				systemImage: "plus"
      ) {
					isAddPresented = true
			}
		}.sheet(isPresented: $isAddPresented) {
			AddPlanView(plan: plan)
		}
	}
}

#Preview {
	let planLeaf = PlanLeaf(Stream("demo", Money(100)))
	let planTree = PlanComposite.makeAndTree("tree")
	planTree.append(planLeaf)

	return PlanTreeView(plan: planTree)
}
