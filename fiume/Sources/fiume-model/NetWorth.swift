public struct NetWorth {
  let scenario: Scenario
  let leias: any Sequence<Leia>
  let range: ClosedRange<MonthYear>

  public init(scenario: Scenario, leias: any Sequence<Leia>, range: ClosedRange<MonthYear>) {
    self.scenario = scenario
    self.leias = leias
    self.range = range
  }

  public func compute() -> ScenarioSummary {
    var result = [MonthlySummary]()
    var netIncomeToDate = Money(0)

    range.forEach { monthYear in
      var typeToMoney = MoneyByType()

      leias.forEach { leia in
        typeToMoney[leia.type] += leia.signedAmount(start: range.lowerBound, at: monthYear, scenario: scenario)
      }

      netIncomeToDate += typeToMoney.netIncome
      let netWorthAtMonth = netIncomeToDate + typeToMoney.netAssets

      result.append(MonthlySummary(month: monthYear, netWorth: netWorthAtMonth))
    }
    return ScenarioSummary(
      name: scenario.name,
      netWorthByMonth: result
    )
  }
}
