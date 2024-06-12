import SwiftUI

struct PlanTreeView: View {
	@Binding var plan: Planxty

	var body: some View {
    switch plan.type {
    case .stream:
      PlanLeafView(stream: plan.stream!)

    case .and:
      PlanAndTreeView(plan: $plan)

    case .or:
      PlanAndTreeView(plan: $plan)
    }
  }
}

struct PlanLeafView: View {
  var stream: Stream

	var body: some View {
		StreamView(stream: stream)
	}
}

struct PlanAndTreeView: View {
  @Binding var plan: Planxty

  var body: some View {
    PlanCompositeView(
      plan: $plan,
      icon: "list.bullet.clipboard",
      label: "Group"
    )
  }
}

struct PlanOrTreeView: View {
  @Binding var plan: Planxty

  var body: some View {
    PlanCompositeView(
      plan: $plan,
      icon: "arrow.left.arrow.right",
      label: "Alternatives"
    )
  }
}

struct PlanCompositeView: View {
	@Binding var plan: Planxty
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
			AddPlanView(plan: $plan)
		}
	}
}

#Preview {
  let planStream = Planxty.makeStream(Stream("demo", Money(100), first: .month(2020.jan), last: .unchanged))
  @State var planTree = Planxty.makeAnd("tree")
	planTree.append(planStream)

	return PlanTreeView(plan: $planTree)
}
