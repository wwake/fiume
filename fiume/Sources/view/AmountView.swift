import fiume_model
import SwiftUI

enum AmountType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case money = "Money",
       relative = "Relative"
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

#Preview {
  let leiaType = LeiaType.income
  @State var amount = Amount(1000)
  return AmountView(leiaType: leiaType, amount: $amount)
}
