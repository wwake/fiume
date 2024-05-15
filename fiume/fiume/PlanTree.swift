import Foundation

protocol PlanTree {
	var name: String { get }
	var children: [PlanTree]? { get }
	func append(_: PlanTree)
	func net(_ month: Int) -> Dollar
}

@Observable
class PlanLeaf: PlanTree {
	let stream: Stream

	init(stream: Stream) {
		self.stream = stream
	}

	var name: String { stream.name }

	var children: [PlanTree]? { nil }

	func net(_ month: Int) -> Dollar {
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

	init(name: String) {
		self.name = name
	}

	func append(_ plan: PlanTree) {
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
