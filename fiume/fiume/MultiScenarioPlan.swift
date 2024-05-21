import Foundation

struct NetWorthData: Identifiable {
	let id = UUID()
	let month: Int
	let amount: Money
}

@Observable
class MultiScenarioPlan {
	var planContents = PlanComposite.makeAndTree("My Finances")
	var sections = [PlanTree]()

	init() {
		sections.append(planContents)
	}

	func add(_ stream: Stream) {
		planContents.append(PlanLeaf(stream))
	}

	func project(_ months: Int) -> [NetWorthData] {
		var result = [NetWorthData]()
		var runningTotal = Money(0)
		(1...months).forEach { month in
			let net = planContents.net(month)
			runningTotal += net
			result.append(NetWorthData(month: month, amount: runningTotal))
		}
		return result
	}

	func concretePlans() -> Set<Scenario> {
		planContents.concretePlans([Scenario()])
	}
}
