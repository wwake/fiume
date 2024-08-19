public struct NetWorth {
  let scenario: Scenario
  let leias: any Sequence<Leia>
  let range: ClosedRange<MonthYear>

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

  public func netIncome(at month: MonthYear) -> Money {
    net(at: month, in: filterBy(.income, .expense))
  }

  public func netAssets(at month: MonthYear) -> Money {
    net(at: month, in: filterBy(.asset, .liability))
  }

  fileprivate func filterBy(_ type1: LeiaType, _ type2: LeiaType) -> [Leia] {
    leias.filter { value in
      value.type == type1 || value.type == type2
    }
  }

  fileprivate func net(at month: MonthYear, in collection: [Leia]) -> Money {
    collection.reduce(Money(0)) { net, leia in
      net + leia.signedAmount(at: month, people: scenario.people, scenario: scenario)
    }
  }
}
