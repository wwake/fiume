import Foundation

class Scenario: Identifiable {
	let id = UUID()
	var items = [String: Stream]()

	init() { }

	convenience init(_ other: Scenario) {
		self.init()
		let copy = other.items
		self.items = copy
	}

	func add(_ stream: Stream) {
		if items[stream.name] == nil {
			items[stream.name] = stream
		} else {
			let original = items[stream.name]!
			let revised = original.merge(stream)
			items[stream.name] = revised
		}
	}

	func net(_ month: MonthNumber) -> Money {
		items.values.reduce(Money(0)) { soFar, stream in
			soFar + stream.amount(month: month)
		}
	}

	func copies(_ count: Int) -> [Scenario] {
		(1...count).map { _ in
			Scenario(self)
		}
	}
}

extension Scenario: Hashable {
	static func == (lhs: Scenario, rhs: Scenario) -> Bool {
		false
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
	}
}

class ScenarioSet {
	var scenarios = Set<Scenario>()

	init(_ scenarios: [Scenario] = []) {
		self.scenarios = Set(scenarios)
	}
}
