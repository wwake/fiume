import Foundation

class ConcretePlan: Identifiable {
	let id = UUID()
	var items = Dictionary<String, Stream>()

	func add(_ stream: Stream) {
		items[stream.name] = stream
	}

	func net(_ month: MonthNumber) -> Money {
		items.values.reduce(Money(0)) { soFar, stream in
			soFar + stream.amount(month: month)
		}
	}
}

extension ConcretePlan: Hashable {
	static func == (lhs: ConcretePlan, rhs: ConcretePlan) -> Bool {
		false
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
	}
}
