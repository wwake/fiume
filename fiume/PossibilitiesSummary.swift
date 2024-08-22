public typealias PossibilitiesSummary = [ScenarioSummary]

public struct ScenarioSummary: Identifiable {
  public let id = UUID()
  public let name: String
  public let netWorthByMonth: [MonthlySummary]
}

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

  public var netIncome: Money {
    self[.income] + self[.expense]
  }

  public var netAssets: Money {
    self[.asset] + self[.liability]
  }
}

public struct MonthlySummary: Identifiable {
  public let id = UUID()
  public let month: MonthYear
  public let netWorth: Money
}
