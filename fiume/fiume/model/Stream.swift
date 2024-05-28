import Foundation

typealias MonthNumber = Int

struct Stream: Identifiable {
	let id = UUID()
	var name: String
	var monthlyAmount: Money
	var first: MonthNumber
	var last: DateSpecifier

  init(
    _ name: String,
    _ monthlyAmount: Money,
    first: MonthNumber,
    last: DateSpecifier
  ) {
		self.name = name
		self.monthlyAmount = monthlyAmount
		self.first = first
		self.last = last
	}

  init(
    _ name: String,
    _ monthlyAmount: Money,
    first: DateSpecifier,
    last: DateSpecifier
  ) {
    self.name = name
    self.monthlyAmount = monthlyAmount

    switch first {
    case .unspecified:
      self.first = 1

    case .month(let month):
      self.first = month
    }

    self.last = last
  }

  var isNonNegative: Bool {
    monthlyAmount >= 0
  }

  func amount(month: MonthNumber) -> Money {
		if month < first { return Money(0) }

    switch last {
    case .unspecified:
      return self.monthlyAmount

    case .month(let lastMonth):
      if month > lastMonth {
        return Money(0)
      } else {
        return self.monthlyAmount
      }
    }
	}

	func merge(_ newer: Stream) -> Stream {
		if self.name != newer.name { return self }

    let newLast: DateSpecifier
    switch newer.last {
    case .unspecified:
      newLast = self.last

    case .month:
      newLast = newer.last
    }

    return Stream(newer.name, newer.monthlyAmount, first: .month(newer.first), last: newLast)
	}
}
