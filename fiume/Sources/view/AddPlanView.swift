import fiume_model
import SwiftUI

struct AddPlanView: View {
  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan
  @State private var planType = PlanType.leia

  var body: some View {
    Text("Add to Plan")
      .font(.title)
      .padding(8)

    Picker("Add New", selection: $planType) {
      Text("Money Source").tag(PlanType.leia)
      Text("Group").tag(PlanType.group)
      Text("Scenarios").tag(PlanType.scenarios)
    }
    .pickerStyle(.segmented)

    switch planType {
    case .leia:
      EditLeiaView(leia: Leia.null, buttonName: "Create") { stream in
        plans.append(parent: plan, child: Plan.make(stream))
      }

    case .group:
      EditGroupView(name: "", buttonName: "Create") { name in
        plans.append(parent: plan, child: Plan.makeGroup(name))
      }

    case .scenarios:
      CreateScenariosView(plan: $plan)

    default:
      fatalError("unknown case \(planType)")
    }

    Spacer()
  }
}

#Preview {
  @State var tree = Plan.makeGroup("accounts")
  @State var plans = Plans()
  let stream = Leia(
    name: "income",
    amount: .money(100),
    dates: DateRange(.month(2024.jan), .unchanged),
    type: .income,
    growth: PercentAssumption.flatGrowth
  )
  tree.append(Plan.make(stream))
  return AddPlanView(plan: $tree)
    .environment(plans)
}
