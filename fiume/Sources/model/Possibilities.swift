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
  var plan = Planxty.makeAnd("My Finances")

  var sections = [Planxty]() { didSet { print("Possibilities set \(sections.map {$0.name})")}}

	init(startDate: MonthYear) {
    self.startMonth = startDate
		sections.append(plan)
	}

	func add(_ stream: Stream) {
    plan.append(Planxty.makeStream(stream))
	}

  func add(_ tree: Planxty) {
    plan.append(tree)
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
		plan.scenarios(Scenarios([Scenario("Scenario")]))
	}
}
