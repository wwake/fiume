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
	var name: String

	private var myChildren: [PlanTree]?

	var children: [PlanTree]? {
		get { myChildren }
	}

	init(_ name: String) {
		self.name = name
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
			result + item.net(month)
		}
	}
}

@Observable
class PlanAndTree: PlanComposite {

}

@Observable
class PlanOrTree: PlanComposite {
	override func net(_ month: Int) -> Money {
		guard let children = children else {
			return Money(0)
		}
		return children.reduce(Money(0)) { result, item in
			max(result, item.net(month))
		}
	}
}
