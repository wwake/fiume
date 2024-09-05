import fiume_model
import SwiftUI

struct CreateScenariosView: View {
  @Environment(\.dismiss)
  var dismiss

  @Environment(Plans.self)
  var plans: Plans

  @Binding var plan: Plan
  @State private var name = ""

  func valid() -> Bool {
    !name.isEmpty
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $name)

      HStack {
        Spacer()
        Button("Create") {
          plans.append(parent: plan, child: Plan.makeScenarios(name))

          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
  }
}

#Preview {
  @State var plans = Plans()
  @State var tree = Plan.makeGroup("accounts")
  let stream = Leia(
    name: "income",
    amount: .money(100),
    dates: DateRange(.month(2020.jan), .unchanged),
    type: .income,
    growth: Assumption.defaultGrowth
  )
  tree.append(Plan.make(stream))
  return CreateScenariosView(plan: $tree)
    .environment(plans)
}
