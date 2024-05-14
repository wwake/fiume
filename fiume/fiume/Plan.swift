import Foundation

struct NetWorthData: Identifiable {
	let id = UUID()
	let month: Int
	let amount: Dollar
}

indirect enum Plan2 {
	case stream(Stream)
	case required(String, [Plan2]?)

	mutating func add(_ stream: Stream) {
		switch self {
		case .stream(_):
			break
		case .required(let name, let plan):
			var newPlan = plan
			newPlan?.append(.stream(stream))
			self = .required(name, newPlan)
		}
	}

	func net(_ month: Int) -> Dollar {
		switch self {
		case .stream(let stream):
			return stream.amount(month: month)

		case .required(_, let contents):
			guard let contents = contents else {
				return Dollar(0)
			}
			return contents.reduce(Dollar(0)) { result, item in
					result + item.net(month)
			}
		}
	}
}

@Observable
class Plan {
	var streams = [Stream]()
	var planContents = Plan2.required("??", [])

	func add(_ stream: Stream) {
		streams.append(stream)

		planContents.add(stream)
	}

	func project(_ months: Int) -> [NetWorthData] {
		var result = [NetWorthData]()
		var runningTotal = Dollar(0)
		(1...months).forEach { month in
//			let net = streams.reduce(Dollar(0)) { result, item in
//				result + item.amount(month: month)
//			}
			let net = planContents.net(month)
			runningTotal += net
			result.append(NetWorthData(month: month, amount: runningTotal))
		}
		return result
	}
}
