import SwiftUI

struct CreateStreamView: View {
  @Environment(\.dismiss)
  var dismiss

  @Bindable var plan: PlanComposite

  @State private var isIncome = true

  @State private var name = ""

  @State private var amount: Int?
  @State private var startMonth: Int?
  @State private var endMonth: Int?

  fileprivate func createdAmount() -> Int {
    guard let amount = amount else { return 0 }
    let sign = isIncome ? 1 : -1
    return sign * amount
  }

  var body: some View {
    Form {
      LabeledContent {
        TextField("Name", text: $name)
      } label: {
        Text("Name")
      }

      Picker(selection: $isIncome, label: Text("Type:")) {
        Text("Income").tag(true)
        Text("Expense").tag(false)
      }

      VStack {
        NumberField(label: "Amount $", value: $amount)
          .padding(2)
          .background(isIncome ? Color("Income") : Color("Expense"))
        if amount != nil && amount! < 0 {
          Text("Amount may not be negative; choose correct Type instead.")
            .foregroundStyle(Color.red)
        }
      }

      NumberField(label: "Start Month", value: $startMonth)

      NumberField(label: "End Month", value: $endMonth)

      HStack {
        Spacer()
        Button("Create") {
          let stream = Stream(
            name,
            Money(createdAmount()),
            first: startMonth ?? 1,
            last: endMonth
          )
          plan.append(PlanLeaf(stream))
          dismiss()
        }
        .disabled(amount != nil && amount! < 0)
        Spacer()
      }
    }
    .autocorrectionDisabled()
  }
}
