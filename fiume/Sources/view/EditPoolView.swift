import fiume_model
import SwiftUI

struct EditPoolView: View {
  @Environment(\.dismiss)
  var dismiss

  var title: String?

  var pool: Leia

  var buttonName: String
  var action: (Leia) -> Void

  @State private var isIncome = true

  @State private var name = ""

  @State private var amountSpec: Amount

  @State private var dates: DateRange

  init(title: String? = nil, pool: Leia, buttonName: String, action: @escaping (Leia) -> Void) {
    self.title = title
    self.pool = pool
    self.buttonName = buttonName
    self.action = action

    self._isIncome = .init(initialValue: pool.isNonNegative)
    self._name = .init(initialValue: pool.name)
    self._amountSpec = .init(initialValue: pool.amount)
    self._dates = .init(initialValue: pool.dates)
  }

  fileprivate func createdAmount() -> Amount {
    switch amountSpec {
    case .money:
      let sign = isIncome ? 1 : -1
      return .money(sign * amountSpec.value())

    case .relative:
      return amountSpec

    @unknown default:
      fatalError("EditPoolView.createdAmount - unknown amount type")
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
          Text("Asset").tag(true)
          Text("Liability").tag(false)
        }

        PoolAmountView(isIncome: isIncome, amount: $amountSpec)

        EditDateRangeView(dates: $dates)

        HStack {
          Spacer()
          Button(buttonName) {
            let outPool = Leia(
              id: pool.id,
              name: name,
              amount: createdAmount(),
              dates: dates,
              leiaType: isIncome ? .asset : .liability
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
}

#Preview {
  @State var pool = Leia(name: "", amount: .money(100), dates: DateRange.null, leiaType: .asset)
  return EditPoolView(pool: pool, buttonName: "Create") { _ in
  }
}
