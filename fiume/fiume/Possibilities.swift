import Foundation

struct MonthlyNetWorth: Identifiable {
	let id = UUID()
	let month: Int
	let amount: Money
}

//(name: String, data: [NetWorthData])
struct ScenarioNetWorth: Identifiable {
  let id = UUID()
  let name: String
  let netWorthByMonth: [MonthlyNetWorth]
}

struct PossibilitiesNetWorth {
  var data: [ScenarioNetWorth]
}

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

  func project(_ months: Int) -> [(name: String, data: [MonthlyNetWorth])] {
		var result = [MonthlyNetWorth]()
		var runningTotal = Money(0)
		(1...months).forEach { month in
			let net = plan.net(month)
			runningTotal += net
			result.append(MonthlyNetWorth(month: month, amount: runningTotal))
		}
    return [(name: "data", data: result)]
	}

	func scenarios() -> Scenarios {
		plan.scenarios(Scenarios([Scenario()]))
	}
}
