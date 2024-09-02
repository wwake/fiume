import fiume_model
import SwiftUI

struct PlanView: View {
  @Environment(\.modelContext)
  var modelContext

  @Binding var plan: Plan

  var body: some View {
    switch plan.type {
    case .leia:
      LeiaView(plan: $plan)

    case .group:
      PlanGroupView(plan: $plan)

    case .scenarios:
      PlanScenariosView(plan: $plan)

    default:
      fatalError("Unknown plan type \(plan.type)")
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
      icon: "arrow.triangle.branch",
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

  @State private var isActiveToggle: Bool

  @State private var isAddPresented = false
  @State private var isEditPresented = false

  init(plan: Binding<Plan>, icon: String, label: String) {
    self._plan = plan
    self.icon = icon
    self.label = label
    self.isActiveToggle = plan.wrappedValue.isActive
  }

  var body: some View {
    HStack {
      Toggle("Active", isOn: $isActiveToggle)
        .labelsHidden()
        .padding([.leading, .trailing], 4)

      Image(systemName: icon)
        .accessibilityLabel(label)

      Text(plan.name)
        .strikethrough(!plan.isActive)

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
    .onChange(of: isActiveToggle) {
      plans.toggle(plan)
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

  let planLeia = Plan.make(Leia(
    name: "demo",
    amount: .money(100),
    dates: DateRange( .month(2020.jan), .unchanged),
    type: .income,
    growth: PercentAssumption.flatGrowth
  ))
  @State var planTree = Plan.makeGroup("an 'and' tree")
  planTree.append(planLeia)

  return PlanView(plan: $planTree)
    .environment(plans)
}
