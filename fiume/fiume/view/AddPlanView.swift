import SwiftUI

enum AddType: String, CaseIterable, Identifiable {
	var id: Self { self }

	case stream, group, scenarios
}

struct AddPlanView: View {
	@Bindable var plan: PlanComposite
	@State private var addType = AddType.stream

	var body: some View {
		Text("Add to Plan")
			.font(.title)
			.padding(8)
		
		Picker("Add New", selection: $addType) {
				ForEach(AddType.allCases) { addType in
						Text(addType.rawValue.capitalized)
				}
		}
		.pickerStyle(.segmented)

		if addType == .stream {
			CreateStreamView(plan: plan)
		} else if addType == .group {
			CreateGroupView(plan: plan)
		} else if addType == .scenarios {
			CreateScenariosView(plan: plan)
		}

		Spacer()
	}
}

#Preview {
	var tree = PlanComposite.makeAndTree("accounts")
	tree.append(PlanLeaf(Stream("income", Money(100))))
	return AddPlanView(plan: tree)
}
