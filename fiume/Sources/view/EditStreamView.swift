import SwiftUI

struct EditStreamView: View {
  @Environment(\.dismiss)
  var dismiss

  var stream: Stream?

  var buttonName: String
  var action: (Stream) -> Void

  init(stream: Stream?, buttonName: String, action: @escaping (Stream) -> Void) {
    self.stream = stream
    self.buttonName = buttonName
    self.action = action

    if stream != nil {
      self._isIncome = .init(initialValue: stream!.isNonNegative)
      self._name = .init(initialValue: stream!.name)
      self._amount = .init(initialValue: stream!.monthlyAmount)
      self._startMonth = .init(initialValue: stream!.first)
      self._endMonth = .init(initialValue: stream!.last)
    }
  }

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

      DateSpecifierView(label: "Start Month", dateSpec: $startMonth)

      DateSpecifierView(label: "End Month", dateSpec: $endMonth)

      HStack {
        Spacer()
        Button(buttonName) {
          let stream = Stream(
            name,
            Money(createdAmount()),
            first: startMonth,
            last: endMonth
          )
          action(stream)

          dismiss()
        }
        .disabled(!valid())
        Spacer()
      }
    }
    .autocorrectionDisabled()
  }
}
