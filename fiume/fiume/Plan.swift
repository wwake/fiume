import Foundation

struct NetWorthData: Identifiable {
	let id = UUID()
	let month: Int
	let amount: Dollar
}

protocol Plan3 {
	var name: String { get }
	var children: [Plan3]? { get }
	func append(_: Plan3)
	func net(_ month: Int) -> Dollar
}

@Observable
class PlanLeaf: Plan3 {
	let stream: Stream

	init(stream: Stream) {
		self.stream = stream
	}

	var name: String { stream.name }

	var children: [Plan3]? { nil }

	func net(_ month: Int) -> Dollar {
		stream.monthlyAmount
	}

	func append(_: Plan3) { }
}

@Observable
class PlanComposite: Plan3 {
	var name: String

	private var myChildren: [Plan3]?

	var children: [Plan3]? {
		get { myChildren }
	}

	init(name: String) {
		self.name = name
	}

	func append(_ plan: Plan3) {
		if myChildren == nil {
			myChildren = [plan]
		} else {
			myChildren!.append(plan)
		}
	}

	func net(_ month: Int) -> Dollar {
		guard let children = children else {
			return Dollar(0)
		}
		return children.reduce(Dollar(0)) { result, item in
			result + item.net(month)
		}
	}
}

indirect enum Plan2 {
	case stream(Stream)
	case required(String, [Plan2]?)

	var name: String {
		switch self {
		case .stream(let stream):
			return stream.name

		case .required(let name, _):
			return name
		}
	}

	var children: [Plan2]? {
		switch self {
		case .stream:
			return []

		case .required(_, let children):
			return children
		}
	}

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

	fileprivate func extractedFunc(_ stream: (Stream), _ month: Int) -> Dollar {
		return stream.amount(month: month)
	}
	
	func net(_ month: Int) -> Dollar {
		switch self {
		case .stream(let stream):
			return extractedFunc(stream, month)

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
	var planContents = PlanComposite(name: "My Finances")
	var contents = [Plan3]()

	init() {
		contents.append(planContents)
	}

	func add(_ stream: Stream) {
		streams.append(stream)

		planContents.append(PlanLeaf(stream: stream))
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
