import Foundation

protocol PlanTree {
	var id: UUID { get }
	var name: String { get }
	var children: [PlanTree]? { get }
	func append(_: PlanTree)
	func net(_ month: Int) -> Money
	func scenarios(_ original: Scenarios) -> Scenarios
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

	func scenarios(_ original: Scenarios) -> Scenarios {
    original.add(stream)
	}
}

@Observable
class PlanComposite: PlanTree, Identifiable {
	static func makeAndTree(_ name: String) -> PlanComposite {
		AndTree(name, +)
	}

	static func makeOrTree(_ name: String) -> PlanComposite {
		OrTree(name, max)
	}

	let id = UUID()
	var name: String
	var combiningOperator: (Money, Money) -> Money

	internal var myChildren: [PlanTree]?

	var children: [PlanTree]? {
		myChildren
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

	func scenarios(_ scenarios: Scenarios) -> Scenarios {
    guard let children = myChildren else {
      return Scenarios(Array(scenarios.scenarios))
    }
		children.forEach {
			_ = $0.scenarios(scenarios)
		}
		return Scenarios(Array(scenarios.scenarios))
	}
}

class AndTree: PlanComposite {
}

class OrTree: PlanComposite {
	override func scenarios(_ scenarios: Scenarios) -> Scenarios {
		guard let children = myChildren else {
      return Scenarios(Array(scenarios.scenarios))
    }

		let result = scenarios.scenarios.map { aScenario in
			let independentScenarios = aScenario.copies(children.count)
			let scenariosForChildren = zip(children, independentScenarios)
				.map { child, scenario in
					child.scenarios(Scenarios([scenario]))
				}
				.flatMap { $0 }
			return scenariosForChildren
		}
		.flatMap { $0 }

    let scenarioList = result
      .map { Array($0.scenarios) }
      .flatMap { $0 }
    return Scenarios(scenarioList)
	}
}
