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
      Text("TBD")

    case .stream:
      EditStreamView(stream: Stream.null, buttonName: "Create") { stream in
        plans.append(parent: plan, child: Plan.makeStream(stream))
      }

    case .group:
      EditGroupView(name: "", buttonName: "Create") { name in
        plans.append(parent: plan, child: Plan.makeAnd(name))
      }

    case .scenarios:
      CreateScenariosView(plan: $plan)
    }

    Spacer()
  }
}

#Preview {
  @State var tree = Plan.makeAnd("accounts")
  tree.append(Plan.makeStream(Stream("income", Money(100), first: .month(2024.jan), last: .unchanged)))
  return AddPlanView(plan: $tree)
}
