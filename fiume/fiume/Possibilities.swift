import Foundation

struct NetWorthData: Identifiable {
	let id = UUID()
	let month: Int
	let amount: Money
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

	func project(_ months: Int) -> [NetWorthData] {
		var result = [NetWorthData]()
		var runningTotal = Money(0)
		(1...months).forEach { month in
			let net = plan.net(month)
			runningTotal += net
			result.append(NetWorthData(month: month, amount: runningTotal))
		}
		return result
	}

	func scenarios() -> Set<Scenario> {
		plan.scenarios(Scenarios([Scenario()]))
	}
}
