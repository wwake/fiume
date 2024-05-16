import Foundation

protocol PlanTree {
	var name: String { get }
	var children: [PlanTree]? { get }
	func append(_: PlanTree)
	func net(_ month: Int) -> Money
}

@Observable
class PlanLeaf: PlanTree {
	let stream: Stream

	init(_ stream: Stream) {
		self.stream = stream
	}

	var name: String { stream.name }

	var children: [PlanTree]? { nil }

	func net(_ month: Int) -> Money {
		stream.monthlyAmount
	}

	func append(_: PlanTree) { }
}

@Observable
class PlanComposite: PlanTree {
	static func makeAndTree(_ name: String) -> PlanComposite {
		PlanComposite(name, +)
	}

	static func makeOrTree(_ name: String) -> PlanComposite {
		PlanComposite(name, max)
	}

	var name: String
	var combiningOperator: (Money, Money) -> Money

	private var myChildren: [PlanTree]?

	var children: [PlanTree]? {
		get { myChildren }
	}

	internal init(_ name: String, _ combiningOperator: @escaping (Money, Money) -> Money) {
		self.name = name
		self.combiningOperator = combiningOperator
	}

	func append(_ plan: PlanTree) {
		if myChildren == nil {
			myChildren = [plan]
		} else {
			myChildren!.append(plan)
		}
	}

	func net(_ month: Int) -> Money {
		guard let children = children else {
			return Money(0)
		}
		let result = children.reduce(Money(0)) { result, item in
			combiningOperator(result, item.net(month))
		}
		return result
	}
}
