import fiume_model
import SwiftUI

struct MoneySpecifierView: View {
  var isIncome: Bool
  @Binding var amount: MoneySpecifier

  @State var dollars: Int

  init(isIncome: Bool, amount: Binding<MoneySpecifier>) {
    self.isIncome = isIncome
    self._amount = .init(projectedValue: amount)
    self.dollars = Int(amount.wrappedValue.value())
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
  return MoneySpecifierView(isIncome: isIncome, amount: $moneySpec)
}
