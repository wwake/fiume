import Foundation

typealias MonthNumber = Int

class Stream: Identifiable {
	let id = UUID()
	var name: String
	var monthlyAmount: Dollar
	var first: MonthNumber
	var last: MonthNumber?

	init(_ name: String, _ monthlyAmount: Dollar, first: MonthNumber = 1, last: MonthNumber? = nil) {
		self.name = name
		self.monthlyAmount = monthlyAmount
		self.first = first
		self.last = last
	}

	func amount(month: MonthNumber) -> Dollar {
		if month < first { return Dollar(0) }
		if last != nil && month > last! { return Dollar(0) }
		return self.monthlyAmount
	}
}
