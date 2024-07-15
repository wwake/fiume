import Foundation

struct MonthlyNetWorth: Identifiable {
	let id = UUID()
	let month: MonthYear
	let amount: Money
}

struct ScenarioNetWorth: Identifiable {
  let id = UUID()
  let name: String
  let netWorthByMonth: [MonthlyNetWorth]
}

typealias PossibilitiesNetWorth = [ScenarioNetWorth]

@Observable
class Possibilities {
  enum CodingKeys: String, CodingKey {
    case _startMonth = "startMonth"
    case _plans = "plans"
    case _people = "people"
  }

  let startMonth: MonthYear

  var plans: [Plan]
  var people: People

  init(startDate: MonthYear, plans: Plans, people: People) {
    self.startMonth = startDate
    self.plans = [plans.plans]
    self.people = people
  }

  func range(_ numberOfMonths: Int) -> ClosedRange<MonthYear> {
    startMonth.range(numberOfMonths)
  }

  func netWorth(_ range: ClosedRange<MonthYear>) -> PossibilitiesNetWorth {
    scenarios()
      .map {
        $0.netWorth(range)
      }
	}

	func scenarios() -> Scenarios {
    plans[0].scenarios(Scenarios([Scenario("Scenario", people: people)]))
	}
}
