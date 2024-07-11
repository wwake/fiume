import SwiftUI

struct AddPlanView: View {
  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan
  @State private var planType = PlanType.pool

  var body: some View {
    Text("Add to Plan")
      .font(.title)
      .padding(8)

    Picker("Add New", selection: $planType) {
      ForEach(PlanType.allCases) { addType in
        Text(addType.rawValue.capitalized)
      }
    }
    .pickerStyle(.segmented)

    switch planType {
    case .pool:
      EditPoolView(pool: Leia.null, buttonName: "Create") { pool in
        plans.append(parent: plan, child: Plan.makePool(pool))
      }

    case .stream:
      EditLeiaView(stream: Leia.null, buttonName: "Create") { stream in
        plans.append(parent: plan, child: Plan.makeLeia(stream))
      }

    case .group:
      EditGroupView(name: "", buttonName: "Create") { name in
        plans.append(parent: plan, child: Plan.makeGroup(name))
      }

    case .scenarios:
      CreateScenariosView(plan: $plan)
    }

    Spacer()
  }
}

#Preview {
  @State var tree = Plan.makeGroup("accounts")
  tree.append(Plan.makeLeia(Leia(name: "income", amount: Money(100), first: .month(2024.jan), last: .unchanged)))
  return AddPlanView(plan: $tree)
}
