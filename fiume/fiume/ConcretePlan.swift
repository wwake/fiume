import Foundation

class ConcretePlan: Identifiable {
	let id = UUID()
}

extension ConcretePlan: Hashable {
	static func == (lhs: ConcretePlan, rhs: ConcretePlan) -> Bool {
		false
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
	}
}
