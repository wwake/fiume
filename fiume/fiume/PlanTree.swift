import Foundation

protocol PlanTree {
	var id: UUID { get }
	var name: String { get }
	var children: [PlanTree]? { get }
	func append(_: PlanTree)
	func net(_ month: Int) -> Money
	func concretePlans(_ original: Set<Scenario>) -> Set<Scenario>
}

@Observable
class PlanLeaf: PlanTree, Identifiable {
	let id = UUID()

	let stream: Stream

	init(_ stream: Stream) {
		self.stream = stream
	}

	var name: String { stream.name }

	var children: [PlanTree]? { nil }

	func net(_ month: Int) -> Money {
		stream.amount(month: month)
	}

	func append(_: PlanTree) { }

	func concretePlans(_ original: Set<Scenario>) -> Set<Scenario> {
		original.forEach {
			$0.add(stream)
		}
		return original
	}
}

@Observable
class PlanComposite: PlanTree, Identifiable {
	static func makeAndTree(_ name: String) -> PlanComposite {
		PlanComposite(name, +)
	}

	static func makeOrTree(_ name: String) -> PlanComposite {
		PlanComposite(name, max)
	}

	let id = UUID()
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
		return children.reduce(Money(0)) { result, item in
			combiningOperator(result, item.net(month))
		}
	}

	func concretePlans(_ plans: Set<Scenario>) -> Set<Scenario> {
		guard let children = myChildren else { return plans }
		children.forEach {
			_ = $0.concretePlans(plans)
		}
		return plans
	}
}
