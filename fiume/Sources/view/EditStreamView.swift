import fiume_model
import SwiftUI

struct EditStreamView: View {
  @Environment(\.dismiss)
  var dismiss

  var stream: Leia

  var buttonName: String
  var action: (Leia) -> Void

  init(stream: Leia, buttonName: String, action: @escaping (Leia) -> Void) {
    self.stream = stream
    self.buttonName = buttonName
    self.action = action

    self._isIncome = .init(initialValue: stream.isNonNegative)
    self._name = .init(initialValue: stream.name)
    self._amount = .init(initialValue: stream.amount)

    self._dates = .init(initialValue: stream.dates)
  }

  @State private var isIncome = true

  @State private var name = ""

  @State private var amount: Int?
  @State private var dates = DateRange.null

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
    return isIncome ? Color("Income") : Color("Expense")
  }

  var body: some View {
    Form {
      RequiredTextField(name: "Name", field: $name)

      Picker(selection: $isIncome, label: Text("Type:")) {
        Text("Income").tag(true)
        Text("Expense").tag(false)
      }

      VStack {
        NumberField(label: "Amount $", value: $amount)
          .padding(2)
          .background(backgroundColor)
        if amount != nil && amount! < 0 {
          Text("Amount may not be negative; choose Income or Expense instead.")
            .foregroundStyle(Color.red)
        }
      }

      EditDateRangeView(dates: $dates)

      HStack {
        Spacer()
        Button(buttonName) {
          let leia = Leia(
            name: name,
            amount: Money(createdAmount()),
            dates: dates
          )
          action(leia)

          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
    .autocorrectionDisabled()
  }
}
