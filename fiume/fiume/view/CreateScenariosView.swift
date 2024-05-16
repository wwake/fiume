import SwiftUI

struct CreateScenariosView: View {
	@Environment(\.dismiss) var dismiss

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
					plan.append(PlanComposite.makeOrTree(name))
					dismiss()
				}
				Spacer()
			}
		}
	}
}

#Preview {
	let tree = PlanComposite.makeAndTree("accounts")
	tree.append(PlanLeaf(Stream("income", Money(100))))
	return CreateScenariosView(plan: tree)
}
