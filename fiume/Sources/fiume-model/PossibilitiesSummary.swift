public typealias PossibilitiesSummary = [ScenarioSummary]

public struct ScenarioSummary: Identifiable {
  public let id = UUID()
  public let name: String
  public let netWorthByMonth: [MonthlySummary]
}

public struct MonthlySummary: Identifiable {
  public let id = UUID()
  public let month: MonthYear
  public let netWorth: Money
}
