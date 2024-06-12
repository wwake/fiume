import Foundation
import SwiftData

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

// @Model
@Observable
class Possibilities {
  let startMonth: MonthYear

  var plan = Plan.makeAnd("My Finances")
  var sections = [Plan]()

	init(startDate: MonthYear) {
    self.startMonth = startDate
		sections.append(plan)
	}

	func add(_ stream: Stream) {
    sections[0].append(Plan.makeStream(stream))
	}

  func add(_ tree: Plan) {
    sections[0].append(tree)
  }

  func range(_ numberOfMonths: Int) -> ClosedRange<MonthYear> {
    startMonth...(startMonth.advanced(by: numberOfMonths - 1))
  }

  func netWorth(_ range: ClosedRange<MonthYear>) -> PossibilitiesNetWorth {
    scenarios()
      .map {
        $0.netWorth(range)
      }
	}

	func scenarios() -> Scenarios {
		sections[0].scenarios(Scenarios([Scenario("Scenario")]))
	}
}
