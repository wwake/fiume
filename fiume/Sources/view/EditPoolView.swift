import SwiftUI

struct EditPoolView: View {
  @Environment(\.dismiss)
  var dismiss

  var pool: Pool

  var buttonName: String
  var action: (Pool) -> Void

  @State private var isIncome = true

  @State private var name = ""

  @State private var amount: Int?
  @State private var startMonth = DateSpecifier.unchanged
  @State private var endMonth = DateSpecifier.unchanged

  fileprivate func createdAmount() -> Int {
    guard let amount else { return 0 }
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

  fileprivate var backgroundColor: Color {
    if amount == nil || amount! <= 0 { return Color("Neutral") }
    return isIncome ? Color("Asset") : Color("Liability")
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $name)

      Picker(selection: $isIncome, label: Text("Type:")) {
        Text("Asset").tag(true)
        Text("Liability").tag(false)
      }

      VStack {
        NumberField(label: "Amount $", value: $amount)
          .padding(2)
          .background(backgroundColor)
        if amount != nil && amount! < 0 {
          Text("Amount may not be negative; choose Asset or Liability instead.")
            .foregroundStyle(Color.red)
        }
      }

      DateSpecifierView(label: "Start Month", dateSpec: $startMonth)

      DateSpecifierView(label: "End Month", dateSpec: $endMonth)

      HStack {
        Spacer()
        Button(buttonName) {
          let outPool = Pool(
            id: pool.id,
            name: name,
            amount: Money(createdAmount()),
            first: startMonth,
            last: endMonth
          )
          action(outPool)

          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
    .autocorrectionDisabled()
  }
}

#Preview {
  @State var pool = Pool(name: "", amount: 100, first: .unchanged, last: .unchanged)
  return EditPoolView(pool: pool, buttonName: "Create") { _ in
  }
}
