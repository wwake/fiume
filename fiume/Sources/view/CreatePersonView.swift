import SwiftUI

struct CreatePersonView: View {
  @Environment(\.dismiss)
  var dismiss

  @Bindable var plan: PlanComposite
  @State private var name = ""
  @State private var born: MonthYear?
  @State private var died: MonthYear?

  func valid() -> Bool {
    !name.isEmpty
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $name)

      LabeledContent {
        MonthYearView(monthYear: $born)
      } label: {
        Text("Born")
          .padding(.trailing, 50)
      }

      LabeledContent {
        MonthYearView(monthYear: $died)
      } label: {
        Text("Died")
          .padding(.trailing, 50)
      }

      HStack {
        Spacer()
        Button("Create") {
          print("TBD")
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
  return CreatePersonView(plan: tree)
}
