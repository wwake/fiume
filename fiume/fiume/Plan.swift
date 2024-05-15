import Foundation

struct NetWorthData: Identifiable {
	let id = UUID()
	let month: Int
	let amount: Dollar
}

@Observable
class Plan {
	var streams = [Stream]()
	var planContents = PlanComposite(name: "My Finances")
	var contents = [PlanTree]()

	init() {
		contents.append(planContents)
	}

	func add(_ stream: Stream) {
		streams.append(stream)

		planContents.append(PlanLeaf(stream))
	}

	func project(_ months: Int) -> [NetWorthData] {
		var result = [NetWorthData]()
		var runningTotal = Dollar(0)
		(1...months).forEach { month in
			let net = planContents.net(month)
			runningTotal += net
			result.append(NetWorthData(month: month, amount: runningTotal))
		}
		return result
	}
}
