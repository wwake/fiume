import Foundation

typealias MonthNumber = Int

struct Stream: Identifiable {
	let id = UUID()
	var name: String
	var monthlyAmount: Money
	var first: MonthNumber
	var last: MonthNumber?

	init(_ name: String, _ monthlyAmount: Money, first: MonthNumber = 1, last: MonthNumber? = nil) {
		self.name = name
		self.monthlyAmount = monthlyAmount
		self.first = first
		self.last = last
	}

  var isNonNegative: Bool {
    monthlyAmount >= 0
  }

  func amount(month: MonthNumber) -> Money {
		if month < first { return Money(0) }
		if last != nil && month > last! { return Money(0) }
		return self.monthlyAmount
	}

	func merge(_ other: Stream) -> Stream {
		if self.name != other.name { return self }

		let newLast = other.last == nil ? self.last : other.last
		return Stream(other.name, other.monthlyAmount, first: other.first, last: newLast)
	}
}

extension Stream: Equatable {
	static func == (lhs: Stream, rhs: Stream) -> Bool {
		lhs.name == rhs.name && lhs.monthlyAmount == rhs.monthlyAmount && lhs.first == rhs.first && lhs.last == rhs.last
	}
}

extension Stream: CustomDebugStringConvertible {
	var debugDescription: String {
		let lastString = self.last == nil ? "nil" : "\(self.last!)"
		return "Stream \(self.name) $\(self.monthlyAmount), months \(self.first):\(lastString)"
	}
}
