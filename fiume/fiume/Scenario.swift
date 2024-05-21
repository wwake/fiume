import Foundation

class Scenario: Identifiable {
	let id = UUID()
	var items = Dictionary<String, Stream>()

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
}

extension Scenario: Hashable {
	static func == (lhs: Scenario, rhs: Scenario) -> Bool {
		false
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
	}
}
