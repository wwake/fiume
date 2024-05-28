import Foundation

typealias MonthNumber = Int

struct Stream: Identifiable {
	let id = UUID()
	var name: String
	var monthlyAmount: Money
	var first2: DateSpecifier
  var first: Int {
    switch first2 {
    case .unspecified:
      return 1

    case .month(let month):
      return month
    }
  }

	var last: DateSpecifier

  init(
    _ name: String,
    _ monthlyAmount: Money,
    first: DateSpecifier,
    last: DateSpecifier
  ) {
    self.name = name
    self.monthlyAmount = monthlyAmount

    self.first2 = first

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

    let newFirst: DateSpecifier
    switch newer.first2 {
    case .unspecified:
      newFirst = self.first2

    case .month:
      newFirst = newer.first2
    }

    let newLast: DateSpecifier
    switch newer.last {
    case .unspecified:
      newLast = self.last

    case .month:
      newLast = newer.last
    }

    return Stream(newer.name, newer.monthlyAmount, first: newFirst, last: newLast)
	}
}
