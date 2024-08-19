struct NetWorth {
  let scenario: Scenario

  let range: ClosedRange<MonthYear>

  init(scenario: Scenario, range: ClosedRange<MonthYear>) {
    self.scenario = scenario
    self.range = range
  }

  func compute() -> ScenarioNetWorth {
    var result = [MonthlyNetWorth]()
    var netIncomeToDate = Money(0)
    range.forEach { monthYear in
      let netIncomeForMonth = scenario.netIncome(at: monthYear)
      netIncomeToDate += netIncomeForMonth

      let netAssetsAtMonth = scenario.netAssets(at: monthYear)
      let netWorthAtMonth = netIncomeToDate + netAssetsAtMonth

      let extractedExpr: MonthlyNetWorth = MonthlyNetWorth(month: monthYear, amount: netWorthAtMonth)
      result.append(extractedExpr)
    }
    return ScenarioNetWorth(name: scenario.name, netWorthByMonth: result)
  }
}
