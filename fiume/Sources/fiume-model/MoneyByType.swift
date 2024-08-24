public struct MoneyByType {
  var typeToMoney = [LeiaType: Money]()

  public init() {
    LeiaType.allCases.forEach {
      typeToMoney[$0] = Money(0)
    }
  }

  public subscript(type: LeiaType) -> Money {
    get { typeToMoney[type]! }
    set { typeToMoney[type] = newValue }
  }

  public mutating func accumulate(_ type: LeiaType, _ money: Money) {
    self[type] += money
  }

  public var netIncome: Money {
    self[.income] + self[.expense]
  }

  public var netAssets: Money {
    self[.asset] + self[.liability]
  }
}
