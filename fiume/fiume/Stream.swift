import Foundation

typealias MonthNumber = Int

class Stream: Identifiable {
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

	func amount(month: MonthNumber) -> Money {
		if month < first { return Money(0) }
		if last != nil && month > last! { return Money(0) }
		return self.monthlyAmount
	}
}
