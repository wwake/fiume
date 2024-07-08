import SwiftUI

struct EditGroupView: View {
  @Environment(\.dismiss)
  var dismiss

  var child: Plan?

  var buttonName: String
  var action: (String) -> Void

  @State private var name = ""

  init(child: Plan?, buttonName: String, action: @escaping (String) -> Void) {
    self.child = child
    self.buttonName = buttonName
    self.action = action
    if child != nil {
      _name = .init(initialValue: child!.name)
    }
  }

  func valid() -> Bool {
    !name.isEmpty
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $name)

      HStack {
        Spacer()
        Button(buttonName) {
          action(name)
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
