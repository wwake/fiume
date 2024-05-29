import SwiftUI

struct CreatePersonView: View {
  @Environment(\.dismiss)
  var dismiss

  @Bindable var plan: PlanComposite
  @State private var name = ""
  @State private var born: MonthYear?
  @State private var died: MonthYear?

  func valid() -> Bool {
    !name.isEmpty
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $name)

      MonthYearView(monthYear: $born)

      MonthYearView(monthYear: $died)

      HStack {
        Spacer()
        Button("Create") {
       //   plan.append(AndTree(name))
          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
  }
}

#Preview {
  let tree = AndTree("accounts")
  tree.append(PlanLeaf(Stream("income", Money(100), first: .month(1), last: .unspecified)))
  return CreatePersonView(plan: tree)
}
