import SwiftUI

struct CreateGroupView: View {
	@Environment(\.dismiss)
	var dismiss

	@Bindable var plan: PlanComposite
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
					plan.append(AndTree(name))
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
  tree.append(PlanLeaf(Stream("income", Money(100), first: .month(MonthYear(.jan, 2020)), last: .unchanged)))
	return CreateGroupView(plan: tree)
}
