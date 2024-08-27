public typealias PossibilitiesSummary = [ScenarioSummary]

public struct ScenarioSummary: Identifiable {
  public let id = UUID()
  public let name: String
  public let netWorthByMonth: [MonthlySummary]
}

extension ScenarioSummary: Hashable {
  public static func == (lhs: ScenarioSummary, rhs: ScenarioSummary) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}

public struct MonthlySummary: Identifiable {
  public let id = UUID()
  public let month: MonthYear
  public let moneyByType: MoneyByType
  public let netWorth: Money
}
