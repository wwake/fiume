import SwiftUI

struct PlanView: View {
  @Environment(\.modelContext)
  var modelContext

  @Binding var plan: Plan

  var body: some View {
    switch plan.type {
    case .stream:
      PlanLeafView(plan: $plan)

    case .and:
      PlanAndTreeView(plan: $plan)

    case .or:
      PlanOrTreeView(plan: $plan)
    }
  }
}

struct PlanLeafView: View {
  @Binding var plan: Plan

  var body: some View {
    StreamView(plan: $plan)
  }
}

struct PlanAndTreeView: View {
  @Binding var plan: Plan

  var body: some View {
    PlanCompositeView(
      plan: $plan,
      icon: "list.bullet.clipboard",
      label: "Group"
    )
  }
}

struct PlanOrTreeView: View {
  @Binding var plan: Plan

  var body: some View {
    PlanCompositeView(
      plan: $plan,
      icon: "arrow.left.arrow.right",
      label: "Alternatives"
    )
  }
}

struct PlanCompositeView: View {
  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan
  let icon: String
  let label: String

  @State private var isAddPresented = false

  var body: some View {
    HStack {
      Image(systemName: icon)
        .accessibilityLabel(label)

      Text(plan.name)
      Spacer()
      Button(action: {
        plans.remove(plan)
      }) {
        Image(systemName: "trash")
          .accessibilityLabel(Text("Delete"))
      }
      .buttonStyle(.plain)

      Button(action: {
        isAddPresented = true
      }) {
        Image(systemName: "plus")
          .accessibilityLabel(Text("Add"))
      }
      .buttonStyle(.plain)
    }.sheet(isPresented: $isAddPresented) {
      AddPlanView(plan: $plan)
    }
  }
}

#Preview {
  @State var plans = Plans()

  let planStream = Plan.makeStream(Stream("demo", Money(100), first: .month(2020.jan), last: .unchanged))
  @State var planTree = Plan.makeAnd("an 'and' tree")
  planTree.append(planStream)

  return PlanView(plan: $planTree)
    .environment(plans)
}
