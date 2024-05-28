import SwiftUI

struct CreateStreamView: View {
  @Environment(\.dismiss)
  var dismiss

  @Bindable var plan: PlanComposite

  @State private var isIncome = true

  @State private var name = ""

  @State private var amount: Int?
  @State private var startMonth = DateSpecifier.unspecified
  @State private var endMonth = DateSpecifier.unspecified

  fileprivate func createdAmount() -> Int {
    guard let amount = amount else { return 0 }
    let sign = isIncome ? 1 : -1
    return sign * amount
  }

  fileprivate func valid() -> Bool {
    if amount != nil && amount! < 0 {
      return false
    }
    if name.isEmpty {
      return false
    }
    return true
  }

  var body: some View {
    Form {
      VStack {
        LabeledContent {
          TextField("Name", text: $name)
        } label: {
          Text("Name")
        }
        if name.isEmpty {
          Text("Name is required.")
            .foregroundStyle(Color.red)
        }
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

      DateSpecifierView(label: "Start Month", dateSpec: $startMonth)

      DateSpecifierView(label: "End Month", dateSpec: $endMonth)

      HStack {
        Spacer()
        Button("Create") {
          let stream = Stream(
            name,
            Money(createdAmount()),
            first: startMonth.asOptionalInt() ?? 1,
            last: endMonth
          )
          plan.append(PlanLeaf(stream))
          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
    .autocorrectionDisabled()
  }
}
