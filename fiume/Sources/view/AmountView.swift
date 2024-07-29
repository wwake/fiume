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

enum AmountType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case money = "Money",
       relative = "Relative"
}

struct MoneyAmountView: View {
  var isIncome: Bool
  var positiveColor: String
  var negativeColor: String

  @Binding var amount: Amount

  @Binding var dollars: Int

  init(
    isIncome: Bool,
    positiveColor: String,
    negativeColor: String,
    amount: Binding<Amount>,
    dollars: Binding<Int>
  ) {
    self.isIncome = isIncome
    self.positiveColor = positiveColor
    self.negativeColor = negativeColor

    self._amount = .init(projectedValue: amount)

    self._dollars = dollars
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
  }
}

struct AmountView: View {
  var isIncome: Bool
  var positiveColor: String
  var negativeColor: String
  @Binding var amount: Amount

  @State var amountType: AmountType = .money

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

    switch amount.wrappedValue {
    case .money(let dollars):
      self.dollars = dollars
      amountType = .money

    case let .relative(ratio, stream):
      self.dollars = 0
      amountType = .relative

    @unknown default:
      fatalError("Amount View unknown type \(amount.wrappedValue)")
    }
  }

  var body: some View {
    VStack {
      HStack {
        Text("Choose Amount")
        Spacer()
      }

      Picker("Add New", selection: $amountType) {
        ForEach(AmountType.allCases) {
          Text($0.rawValue.capitalized)
        }
      }
      .pickerStyle(.segmented)
      //      .onChange(of: dateType) { _, newValue in
      //        updateDateSpec(newValue)
      //      }

      switch amountType {
      case .money:
        MoneyAmountView(isIncome: isIncome, positiveColor: positiveColor, negativeColor: negativeColor, amount: $amount, dollars: $dollars)
          .frame(height: 100)

      case .relative:
        EmptyView()
          .frame(height: 100)
      }
    }
  }
}

#Preview {
  let isIncome = true
  @State var amount = Amount(1000)
  return PoolAmountView(isIncome: isIncome, amount: $amount)
}
