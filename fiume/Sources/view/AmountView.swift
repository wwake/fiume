import fiume_model
import SwiftUI

struct StreamAmountView: View {
  var isIncome: Bool
  @Binding var amount: Amount

  var body: some View {
    AmountView(
      isIncome: isIncome,
      positiveColor: "Income",
      negativeColor: "Expense",
      amount: $amount
    )
  }
}

struct PoolAmountView: View {
  var isIncome: Bool
  @Binding var amount: Amount

  var body: some View {
    AmountView(
      isIncome: isIncome,
      positiveColor: "Asset",
      negativeColor: "Liability",
      amount: $amount
    )
  }
}

struct AmountView: View {
  var isIncome: Bool
  var positiveColor: String
  var negativeColor: String
  @Binding var amount: Amount

  @State var dollars: Int

  init(
    isIncome: Bool,
    positiveColor: String,
    negativeColor: String,
    amount: Binding<Amount>
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
      amount = Amount.money(dollars)
    }
  }
}

#Preview {
  let isIncome = true
  @State var amount = Amount(1000)
  return PoolAmountView(isIncome: isIncome, amount: $amount)
}
