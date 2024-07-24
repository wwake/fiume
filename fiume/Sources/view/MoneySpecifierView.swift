import fiume_model
import SwiftUI

struct StreamMoneySpecifierView: View {
  var isIncome: Bool
  @Binding var amount: MoneySpecifier

  var body: some View {
    MoneySpecifierView(
      isIncome: isIncome,
      positiveColor: "Income",
      negativeColor: "Expense",
      amount: $amount
    )
  }
}

struct PoolMoneySpecifierView: View {
  var isIncome: Bool
  @Binding var amount: MoneySpecifier

  var body: some View {
    MoneySpecifierView(
      isIncome: isIncome,
      positiveColor: "Asset",
      negativeColor: "Liability",
      amount: $amount
    )
  }
}

struct MoneySpecifierView: View {
  var isIncome: Bool
  var positiveColor: String
  var negativeColor: String
  @Binding var amount: MoneySpecifier

  @State var dollars: Int

  init(
    isIncome: Bool,
    positiveColor: String,
    negativeColor: String,
    amount: Binding<MoneySpecifier>
  ) {
    self.isIncome = isIncome
    self.positiveColor = positiveColor
    self.negativeColor = negativeColor
    self._amount = .init(projectedValue: amount)
    self.dollars = abs(Int(amount.wrappedValue.value()))
  }

  fileprivate var backgroundColor: Color {
    if dollars <= 0 { return Color("Neutral") }
    return isIncome ? Color("Asset") : Color("Liability")
  }

  var body: some View {
    VStack {
      NumberField(label: "Amount $", value: $dollars)
        .padding(2)
        .background(backgroundColor)
      if dollars < 0 {
        Text("Amount may not be negative; choose Asset or Liability instead.")
          .foregroundStyle(Color.red)
      }
    }
    .onChange(of: dollars) {
      amount = MoneySpecifier.amount(dollars)
    }
  }
}

#Preview {
  let isIncome = true
  @State var moneySpec = MoneySpecifier.amount(1000)
  return PoolMoneySpecifierView(isIncome: isIncome, amount: $moneySpec)
}