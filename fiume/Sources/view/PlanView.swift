import SwiftUI

struct PlanView: View {
  @Environment(\.modelContext)
  var modelContext

  @Binding var plan: Plan

  var body: some View {
    switch plan.type {
    case .pool:
      PoolView(plan: $plan)

    case .stream:
      LeiaView(plan: $plan)

    case .group:
      PlanGroupView(plan: $plan)

    case .scenarios:
      PlanScenariosView(plan: $plan)
    }
  }
}

struct PlanGroupView: View {
  @Binding var plan: Plan

  var body: some View {
    PlanCompositeView(
      plan: $plan,
      icon: "list.bullet.clipboard",
      label: "Group"
    )
  }
}

struct PlanScenariosView: View {
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
  @State private var isEditPresented = false

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
        isEditPresented = true
      }) {
        Image(systemName: "square.and.pencil")
          .accessibilityLabel(Text("Edit"))
      }
      .buttonStyle(.plain)

      Button(action: {
        isAddPresented = true
      }) {
        Image(systemName: "plus")
          .accessibilityLabel(Text("Add"))
      }
      .buttonStyle(.plain)
    }
    .sheet(isPresented: $isAddPresented) {
      AddPlanView(plan: $plan)
    }
    .sheet(isPresented: $isEditPresented) {
      EditGroupView(name: plan.name, buttonName: "Update") { name in
        plans.rename(plan, name)
      }
    }
  }
}

#Preview {
  @State var plans = Plans()

  let planLeia = Plan.makeLeia(Leia("demo", Money(100), first: .month(2020.jan), last: .unchanged))
  @State var planTree = Plan.makeGroup("an 'and' tree")
  planTree.append(planLeia)

  return PlanView(plan: $planTree)
    .environment(plans)
}
