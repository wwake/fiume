import SwiftUI

enum AddType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case stream, group, scenarios
}

struct AddPlanView: View {
  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan
  @State private var addType = AddType.stream

  var body: some View {
    Text("Add to Plan")
      .font(.title)
      .padding(8)

    Picker("Add New", selection: $addType) {
      ForEach(AddType.allCases) { addType in
        Text(addType.rawValue.capitalized)
      }
    }
    .pickerStyle(.segmented)

    switch addType {
    case .stream:
      EditStreamView(parent: $plan, buttonName: "Create") { stream in
        let newPlan = Plan.makeStream(stream)
        plans.append(parent: plan, child: newPlan)
        plans.wasChanged = true
      }

    case .group:
      EditGroupView(child: nil, buttonName: "Create") { name in
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
