import SwiftUI

struct CreateScenariosView: View {
	@Environment(\.dismiss)
	var dismiss

	@Bindable var plan: PlanComposite
	@State private var name = ""

  func valid() -> Bool {
    !name.isEmpty
  }

	var body: some View {
		Form {
      RequiredTextField(name: "Name", field: $name, message: "Name is required.")

			HStack {
				Spacer()
				Button("Create") {
					plan.append(OrTree(name))
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
	return CreateScenariosView(plan: tree)
}
