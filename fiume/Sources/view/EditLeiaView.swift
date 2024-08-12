import fiume_model
import SwiftUI

struct EditLeiaView: View {
  @Environment(\.dismiss)
  var dismiss

  var title: String?
  var stream: Leia

  var buttonName: String
  var action: (Leia) -> Void

  @State private var leiaType = LeiaType.income

  @State private var name = ""

  @State private var amount: Amount

  @State private var dates = DateRange.always

  init(title: String? = nil, stream: Leia, buttonName: String, action: @escaping (Leia) -> Void) {
    self.title = title
    self.stream = stream
    self.buttonName = buttonName
    self.action = action

    self._leiaType = .init(initialValue: stream.type)
    self._name = .init(initialValue: stream.name)
    self._amount = .init(initialValue: stream.amount)
    self._dates = .init(initialValue: stream.dates)
  }

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

        Picker(selection: $leiaType, label: Text("Type:")) {
          Text(LeiaType.asset.name).tag(LeiaType.asset)
          Text(LeiaType.income.name).tag(LeiaType.income)
          Text(LeiaType.expense.name).tag(LeiaType.expense)
          Text(LeiaType.liability.name).tag(LeiaType.liability)
        }

        AmountView(leiaType: leiaType, amount: $amount)

        EditDateRangeView(dates: $dates)

        HStack {
          Spacer()
          Button(buttonName) {
            let leia = Leia(
              name: name,
              amount: amount,
              dates: dates,
              type: leiaType
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
