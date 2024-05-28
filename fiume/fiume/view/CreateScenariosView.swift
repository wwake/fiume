import SwiftUI

struct CreateScenariosView: View {
	@Environment(\.dismiss)
	var dismiss

	@Bindable var plan: PlanComposite
	@State private var name = ""

	var body: some View {
		Form {
			LabeledContent {
				TextField("Name", text: $name)
			} label: {
				Text("Name")
			}

			HStack {
				Spacer()
				Button("Create") {
					plan.append(OrTree(name))
					dismiss()
				}
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
