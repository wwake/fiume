import SwiftUI

struct PlanTreeView: View {
	var plan: PlanTree

	var body: some View {
		if plan is PlanStream {
			PlanLeafView(plan: plan as! PlanStream)
    } else if plan is AndTree {
      PlanAndTreeView(plan: plan as! PlanComposite)
    } else if plan is OrTree {
      PlanOrTreeView(plan: plan as! PlanComposite)
    }
  }
}

struct PlanLeafView: View {
	var plan: PlanStream

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
  let planStream = PlanStream(Stream("demo", Money(100), first: .month(2020.jan), last: .unchanged))
	let planTree = AndTree("tree")
	planTree.append(planStream)

	return PlanTreeView(plan: planTree)
}
