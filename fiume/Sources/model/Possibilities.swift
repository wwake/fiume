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
  let startMonth: MonthYear
  var plan = AndTree("My Finances")
  var sections = [PlanTree]()

	init(startDate: MonthYear) {
    self.startMonth = startDate
		sections.append(plan)
	}

	func add(_ stream: Stream) {
		plan.append(PlanLeaf(stream))
	}

  func add(_ tree: PlanTree) {
    plan.append(tree)
  }

  func range(_ numberOfMonths: Int) -> ClosedRange<MonthYear> {
    startMonth...(startMonth.advanced(by: numberOfMonths - 1))
  }

  func project(_ range: ClosedRange<MonthYear>) -> PossibilitiesNetWorth {
    scenarios()
      .map {
        $0.project(range)
      }
	}

	func scenarios() -> Scenarios {
		plan.scenarios(Scenarios([Scenario("Scenario")]))
	}
}
