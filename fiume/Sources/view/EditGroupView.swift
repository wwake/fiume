import SwiftUI

struct EditGroupView: View {
	@Environment(\.dismiss)
	var dismiss

  var child: Plan?

  var buttonName: String
  var action: (String) -> Void

	@State private var name = ""

  func valid() -> Bool {
    !name.isEmpty
  }

	var body: some View {
		Form {
      RequiredTextField(name: "Name", field: $name)

			HStack {
				Spacer()
        if child == nil {
          Button(buttonName) {
            action(name)
            dismiss()
          }
          .disabled(!valid())
        }
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