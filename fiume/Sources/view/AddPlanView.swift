import SwiftUI

enum AddType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case stream, group, scenarios
}

struct AddPlanView: View {
  @Bindable var plan: PlanComposite
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
      CreateStreamView(plan: plan)

    case .group:
      CreateGroupView(plan: plan)

    case .scenarios:
      CreateScenariosView(plan: plan)
    }

    Spacer()
  }
}

#Preview {
  let tree = AndTree("accounts")
  tree.append(PlanLeaf(Stream("income", Money(100), first: .month_(1), last: .unchanged)))
  return AddPlanView(plan: tree)
}
