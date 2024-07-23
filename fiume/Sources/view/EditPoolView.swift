import fiume_model
import SwiftUI

struct EditPoolView: View {
  @Environment(\.dismiss)
  var dismiss

  var pool: Leia

  var buttonName: String
  var action: (Leia) -> Void

  @State private var isIncome = true

  @State private var name = ""

  @State private var amount: Int?

  @State private var dates = DateRange.null

  init(pool: Leia, buttonName: String, action: @escaping (Leia) -> Void) {
    self.pool = pool
    self.buttonName = buttonName
    self.action = action

    self._isIncome = .init(initialValue: pool.isNonNegative)
    self._name = .init(initialValue: pool.name)
    self._amount = .init(initialValue: abs(pool.amount))
    self._dates = .init(initialValue: pool.dates)
  }

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

      EditDateRangeView(dates: $dates)

      HStack {
        Spacer()
        Button(buttonName) {
          let outPool = Leia(
            id: pool.id,
            name: name,
            amount: Money(createdAmount()),
            dates: dates
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
  @State var pool = Leia(name: "", amount: 100, dates: DateRange.null)
  return EditPoolView(pool: pool, buttonName: "Create") { _ in
  }
}
