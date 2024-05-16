import SwiftUI

struct CreateGroupView: View {
	@Bindable var plan: PlanComposite

	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

#Preview {
	var tree = PlanComposite.makeAndTree("accounts")
	tree.append(PlanLeaf(Stream("income", Money(100))))
	return CreateGroupView(plan: tree)
}
