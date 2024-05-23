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
	var plan = PlanComposite.makeAndTree("My Finances")
	var sections = [PlanTree]()

	init() {
		sections.append(plan)
	}

	func add(_ stream: Stream) {
		plan.append(PlanLeaf(stream))
	}

  func project(_ months: Int) -> PossibilitiesNetWorth {
		var result = [MonthlyNetWorth]()
		var runningTotal = Money(0)
		(1...months).forEach { month in
			let net = plan.net(month)
			runningTotal += net
			result.append(MonthlyNetWorth(month: month, amount: runningTotal))
		}
    let scenarioNetWorth = ScenarioNetWorth(name: "My Finances", netWorthByMonth: result)
    return PossibilitiesNetWorth([scenarioNetWorth])
	}

	func scenarios() -> Scenarios {
		plan.scenarios(Scenarios([Scenario()]))
	}
}
