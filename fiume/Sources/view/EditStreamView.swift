import fiume_model
import SwiftUI

struct EditStreamView: View {
  @Environment(\.dismiss)
  var dismiss

  var title: String?
  var stream: Leia

  var buttonName: String
  var action: (Leia) -> Void

  init(title: String? = nil, stream: Leia, buttonName: String, action: @escaping (Leia) -> Void) {
    self.title = title
    self.stream = stream
    self.buttonName = buttonName
    self.action = action

    self._isIncome = .init(initialValue: stream.type == .income)
    self._name = .init(initialValue: stream.name)
    self._amount = .init(initialValue: stream.amount)
    self._dates = .init(initialValue: stream.dates)
  }

  @State private var isIncome = true

  @State private var name = ""

  @State private var amount: Amount

  @State private var dates = DateRange.null

  fileprivate func valid() -> Bool {
    if !amount.isNonNegative {
      return false
    }
    if name.isEmpty {
      return false
    }
    return true
  }

  var body: some View {
    VStack {
      if title != nil {
        Text(title!)
          .font(.title)
          .padding()
      }

      Form {
        RequiredTextField(name: "Name", field: $name)

        Picker(selection: $isIncome, label: Text("Type:")) {
          Text("Income").tag(true)
          Text("Expense").tag(false)
        }

        StreamAmountView(isIncome: isIncome, amount: $amount)

        EditDateRangeView(dates: $dates)

        HStack {
          Spacer()
          Button(buttonName) {
            let leia = Leia(
              name: name,
              amount: amount,
              dates: dates,
              leiaType: isIncome ? .income : .expense
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
}
