import fiume_model
import SwiftUI

struct StreamAmountView: View {
  var leiaType: LeiaType
  @Binding var amount: Amount

  var body: some View {
    AmountView(
      leiaType: leiaType,
      amount: $amount
    )
  }
}

struct PoolAmountView: View {
  var isIncome: Bool
  @Binding var amount: Amount

  var body: some View {
    OldAmountView(
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

struct Old_MoneyAmountView: View {
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
        .onChange(of: dollars) {
          amount = .money(dollars)
        }
      if dollars < 0 {
        Text("Amount may not be negative; choose Asset or Liability instead.")
          .foregroundStyle(Color.red)
      }
    }
  }
}

struct MoneyAmountView: View {
  var leiaType: LeiaType

  @Binding var amount: Amount

  @Binding var dollars: Int

  init(
    leiaType: LeiaType,
    amount: Binding<Amount>,
    dollars: Binding<Int>
  ) {
    self.leiaType = leiaType

    self._amount = .init(projectedValue: amount)

    self._dollars = dollars
  }

  fileprivate var backgroundColor: Color {
    Color(leiaType.name)
  }

  var body: some View {
    VStack {
      NumberField(label: "Amount $", value: $dollars)
        .padding(2)
        .background(backgroundColor)
        .onChange(of: dollars) {
          amount = .money(dollars)
        }
      if dollars < 0 {
        Text("Amount may not be negative; choose Asset or Liability instead.")
          .foregroundStyle(Color.red)
      }
    }
  }
}

struct RelativeAmountView: View {
  @Binding var amount: Amount
  @Binding var percent: Double
  @Binding var name: String

  func updateValues() {
    amount = .relative(percent, name)
  }

  var body: some View {
    VStack {
      PercentField(label: "Percent", value: $percent)
        .padding(2)

      RequiredTextField(name: "Source", field: $name)
    }
    .onChange(of: percent) {
      updateValues()
    }
    .onChange(of: name) {
      updateValues()
    }
  }
}

struct OldAmountView: View {
  var isIncome: Bool
  var positiveColor: String
  var negativeColor: String
  @Binding var amount: Amount

  @State var amountType: AmountType

  @State var dollars: Int
  @State var percent: Double
  @State var name: String

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
      self.percent = 1.0
      self.name = ""
      amountType = .money

    case let .relative(ratio, stream):
      self.dollars = 0
      self.percent = ratio
      self.name = stream
      amountType = .relative

    @unknown default:
      fatalError("Amount View unknown type \(amount.wrappedValue)")
    }
  }

  func updateValues() {
    switch amountType {
    case .money:
      amount = .money(Money(self.dollars))

    case .relative:
      amount = .relative(self.percent, self.name)
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
      .onChange(of: amountType) {
        updateValues()
      }

      switch amountType {
      case .money:
        Old_MoneyAmountView(
          isIncome: isIncome,
          positiveColor: positiveColor,
          negativeColor: negativeColor,
          amount: $amount,
          dollars: $dollars
        )
        .frame(height: 80)

      case .relative:
        RelativeAmountView(
          amount: $amount,
          percent: $percent,
          name: $name
        )
          .frame(height: 80)
      }
    }
  }
}

struct AmountView: View {
  var leiaType: LeiaType
  @Binding var amount: Amount

  @State var amountType: AmountType

  @State var dollars: Int
  @State var percent: Double
  @State var name: String

  init(
    leiaType: LeiaType,
    amount: Binding<Amount>
  ) {
    self.leiaType = leiaType
    self._amount = .init(projectedValue: amount)

    switch amount.wrappedValue {
    case .money(let dollars):
      self.dollars = dollars
      self.percent = 1.0
      self.name = ""
      amountType = .money

    case let .relative(ratio, stream):
      self.dollars = 0
      self.percent = ratio
      self.name = stream
      amountType = .relative

    @unknown default:
      fatalError("Amount View unknown type \(amount.wrappedValue)")
    }
  }

  func updateValues() {
    switch amountType {
    case .money:
      amount = .money(Money(self.dollars))

    case .relative:
      amount = .relative(self.percent, self.name)
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
      .onChange(of: amountType) {
        updateValues()
      }

      switch amountType {
      case .money:
        MoneyAmountView(
          leiaType: leiaType,
          amount: $amount,
          dollars: $dollars
        )
        .frame(height: 80)

      case .relative:
        RelativeAmountView(
          amount: $amount,
          percent: $percent,
          name: $name
        )
          .frame(height: 80)
      }
    }
  }
}

#Preview {
  let isIncome = true
  @State var amount = Amount(1000)
  return PoolAmountView(isIncome: isIncome, amount: $amount)
}
