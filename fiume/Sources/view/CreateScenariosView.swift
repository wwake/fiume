import SwiftUI

struct CreateScenariosView: View {
	@Environment(\.dismiss)
	var dismiss

	@Binding var plan: Planxty
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
          plan.append(Planxty.makeOr(name))
					dismiss()
				}
        .disabled(!valid())
				Spacer()
			}
		}
	}
}

#Preview {
  @State var tree = Planxty.makeAnd("accounts")
  tree.append(Planxty.makeStream(Stream("income", Money(100), first: .month(2020.jan), last: .unchanged)))
	return CreateScenariosView(plan: $tree)
}
