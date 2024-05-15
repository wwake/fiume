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

	var body: some View {
		Text(plan.name)
	}
}

#Preview {
	let planLeaf = PlanLeaf(Stream("demo", Dollar(100)))
	var planTree = PlanComposite("tree")
	planTree.append(planLeaf)

	return PlanTreeView(plan: planTree)
}
