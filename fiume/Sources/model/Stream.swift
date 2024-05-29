import Foundation

typealias MonthNumber = Int

struct Stream: Identifiable {
  let id = UUID()
  var name: String
  var monthlyAmount: Money
  var first: DateSpecifier
  var last: DateSpecifier

  init(
    _ name: String,
    _ monthlyAmount: Money,
    first: DateSpecifier,
    last: DateSpecifier
  ) {
    self.name = name
    self.monthlyAmount = monthlyAmount

    self.first = first

    self.last = last
  }

  var isNonNegative: Bool {
    monthlyAmount >= 0
  }

  func amount(month: MonthNumber) -> Money {
    if case let .month(streamFirstMonth) = first, month < streamFirstMonth {
      return Money(0)
    }

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
    switch newer.first {
    case .unspecified:
      newFirst = self.first

    case .month:
      newFirst = newer.first
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
