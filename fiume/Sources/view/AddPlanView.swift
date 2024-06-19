import SwiftUI

enum AddType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case stream, group, scenarios
}

struct AddPlanView: View {
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
      CreateStreamView(parent: $plan)

    case .group:
      CreateGroupView(plan: $plan)

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
