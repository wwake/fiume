import SwiftUI

struct EditGroupView: View {
  @Environment(\.dismiss)
  var dismiss

  var plan: Plan?

  var buttonName: String
  var action: (String) -> Void

  @State private var nameField = ""

  init(child: Plan?, buttonName: String, action: @escaping (String) -> Void) {
    self.plan = child
    self.buttonName = buttonName
    self.action = action
    if child != nil {
      _nameField = .init(initialValue: child!.name)
    }
  }

  func valid() -> Bool {
    !nameField.isEmpty
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $nameField)

      HStack {
        Spacer()
        Button(buttonName) {
          action(nameField)
          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
  }
}

#Preview {
  @State var tree = Plan.makeAnd("accounts")
  tree.append(Plan.makeStream(Stream("income", Money(100), first: .month(2020.jan), last: .unchanged)))
  return EditGroupView(child: nil, buttonName: "Create") { _ in }
}
