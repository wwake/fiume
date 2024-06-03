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

  func amount(for: MonthYear, month: MonthNumber) -> Money {
    if case let .month(streamFirstMonth) = first, month < streamFirstMonth {
      return Money(0)
    }

    switch last {
    case .unchanged:
      return self.monthlyAmount

    case .month(let lastMonth):
      if month > lastMonth {
        return Money(0)
      } else {
        return self.monthlyAmount
      }

    case .age:
      return Money(-1)
    }
  }

  func update(overriddenBy stream: Stream) -> Stream {
    if self.name != stream.name { return self }

    let newFirst = self.first.update(using: stream.first)
    let newLast = self.last.update(using: stream.last)

    return Stream(stream.name, stream.monthlyAmount, first: newFirst, last: newLast)
  }
}
