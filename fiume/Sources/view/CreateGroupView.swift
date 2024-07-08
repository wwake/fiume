import SwiftUI

struct CreateGroupView: View {
	@Environment(\.dismiss)
	var dismiss

  @Environment(Plans.self)
  var plans: Plans

	@Binding var parent: Plan
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
  @State var plans = Plans()
  @State var tree = Plan.makeAnd("accounts")
  tree.append(Plan.makeStream(Stream("income", Money(100), first: .month(2020.jan), last: .unchanged)))
  return CreateGroupView(parent: $tree, child: nil, buttonName: "Create") { _ in }
    .environment(plans)
}
