import SwiftUI

struct CreateScenariosView: View {
	@Environment(\.dismiss)
	var dismiss

	@Binding var plan: Plan
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
          plan.append(Plan.makeOr(name))
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
	return CreateScenariosView(plan: $tree)
}
