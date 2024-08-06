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

    self._isIncome = .init(initialValue: stream.isNonNegative)
    self._name = .init(initialValue: stream.name)
    self._amountSpec = .init(initialValue: stream.amount)
    self._dates = .init(initialValue: stream.dates)
  }

  @State private var isIncome = true

  @State private var name = ""

  @State private var amountSpec: Amount

  @State private var dates = DateRange.null

  fileprivate func createdAmount() -> Amount {
    switch amountSpec {
    case .money(let money):
      let sign = isIncome ? 1 : -1
      return .money(sign * amountSpec.value())

    case .relative(let double, let string):
      return amountSpec

    @unknown default:
      fatalError("EditStreamView.createdAmount - unknown amount type")
    }
  }

  fileprivate func valid() -> Bool {
//    if amountSpec.value() < 0 {
//      return false
//    }
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

        StreamAmountView(isIncome: isIncome, amount: $amountSpec)

        EditDateRangeView(dates: $dates)

        HStack {
          Spacer()
          Button(buttonName) {
            let leia = Leia(
              name: name,
              amount: createdAmount(),
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
}
