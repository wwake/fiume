import fiume_model
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
    case .pool, .stream:
      EditLeiaView(stream: Leia.null, buttonName: "Create") { stream in
        plans.append(parent: plan, child: Plan.make(stream: stream))
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
    type: .income
  )
  tree.append(Plan.make(stream: stream))
  return AddPlanView(plan: $tree)
    .environment(plans)
}
