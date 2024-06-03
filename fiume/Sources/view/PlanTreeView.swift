import SwiftUI

struct PlanTreeView: View {
	var plan: PlanTree

	var body: some View {
		if plan is PlanLeaf {
			PlanLeafView(plan: plan as! PlanLeaf)
    } else if plan is AndTree {
      PlanAndTreeView(plan: plan as! PlanComposite)
    } else if plan is OrTree {
      PlanOrTreeView(plan: plan as! PlanComposite)
    }
  }
}

struct PlanLeafView: View {
	var plan: PlanLeaf

	var body: some View {
		StreamView(stream: plan.stream)
	}
}

struct PlanAndTreeView: View {
  var plan: PlanComposite

  var body: some View {
    PlanCompositeView(
      plan: plan,
      icon: "list.bullet.clipboard",
      label: "Group"
    )
  }
}

struct PlanOrTreeView: View {
  var plan: PlanComposite

  var body: some View {
    PlanCompositeView(
      plan: plan,
      icon: "arrow.left.arrow.right",
      label: "Alternatives"
    )
  }
}

struct PlanCompositeView: View {
	var plan: PlanComposite
  let icon: String
  let label: String

	@State private var isAddPresented = false

	var body: some View {
		HStack {
      Image(systemName: icon)
        .accessibilityLabel(label)

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
  let planLeaf = PlanLeaf(Stream("demo", Money(100), first: .month(1), last: .unchanged))
	let planTree = AndTree("tree")
	planTree.append(planLeaf)

	return PlanTreeView(plan: planTree)
}
