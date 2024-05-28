import Foundation

struct MonthlyNetWorth: Identifiable {
	let id = UUID()
	let month: Int
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
	var plan = AndTree("My Finances")
	var sections = [PlanTree]()

	init() {
		sections.append(plan)
	}

	func add(_ stream: Stream) {
		plan.append(PlanLeaf(stream))
	}

  func add(_ tree: PlanTree) {
    plan.append(tree)
  }

  func project(_ months: Int) -> PossibilitiesNetWorth {
    scenarios()
      .map {
        $0.project(1...months)
      }
	}

	func scenarios() -> Scenarios {
		plan.scenarios(Scenarios([Scenario("")]))
	}
}
