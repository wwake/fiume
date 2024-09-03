import fiume_model
import SwiftUI

struct EditLeiaView: View {
  @Environment(\.dismiss)
  var dismiss

  @Environment(PercentAssumptions.self)
  var assumptions: PercentAssumptions

  var title: String?
  var leia: Leia

  var buttonName: String
  var action: (Leia) -> Void

  @State private var leiaType = LeiaType.income

  @State private var name: String
  @State private var growth = Assumption.flatGrowth

  @State private var amount: Amount

  @State private var dates = DateRange.always

  init(title: String? = nil, leia: Leia, buttonName: String, action: @escaping (Leia) -> Void) {
    self.title = title
    self.leia = leia
    self.buttonName = buttonName
    self.action = action

    self._leiaType = .init(initialValue: leia.type)
    self._name = .init(initialValue: leia.name)
    self._amount = .init(initialValue: leia.amount)
    self._dates = .init(initialValue: leia.dates)
  }

  fileprivate func valid() -> Bool {
    if !amount.isNonNegative {
      return false
    }
    if growth.isEmpty {
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

        Picker(selection: $growth, label: Text("Growth:")) {
          ForEach(Array(assumptions)) {
            Text($0.name).tag($0.name)
          }
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
              type: leiaType,
              growth: growth
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
    .onAppear {
      growth = assumptions.verified(leia.growth!)
    }
  }
}
