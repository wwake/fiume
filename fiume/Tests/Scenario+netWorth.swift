import fiume_model

func netWorth(_ scenario: Scenario, _ monthYear: MonthYear) -> Int {
  scenario
    .netWorth(monthYear...monthYear)
    .netWorthByMonth
    .first!
    .netWorth
}
