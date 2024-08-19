public struct NetWorth {
  let scenario: Scenario

  let range: ClosedRange<MonthYear>

  public init(scenario: Scenario, range: ClosedRange<MonthYear>) {
    self.scenario = scenario
    self.range = range
  }

  public func compute() -> [MonthlyNetWorth] {
    var result = [MonthlyNetWorth]()
    var netIncomeToDate = Money(0)
    range.forEach { monthYear in
      let netIncomeForMonth = scenario.netIncome(at: monthYear)
      netIncomeToDate += netIncomeForMonth

      let netAssetsAtMonth = scenario.netAssets(at: monthYear)
      let netWorthAtMonth = netIncomeToDate + netAssetsAtMonth

      result.append(MonthlyNetWorth(month: monthYear, amount: netWorthAtMonth))
    }
    return result
  }
}
