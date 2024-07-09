import SwiftUI

struct EditGroupView: View {
  @Environment(\.dismiss)
  var dismiss

  var buttonName: String
  var action: (String) -> Void

  @State private var nameField = ""

  init(name: String, buttonName: String, action: @escaping (String) -> Void) {
    self.buttonName = buttonName
    self.action = action
    _nameField = .init(initialValue: name)
  }

  func valid() -> Bool {
    !nameField.isEmpty
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $nameField)
        .disableAutocorrection(true)

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
  EditGroupView(name: "accounts", buttonName: "Create") { _ in }
}
