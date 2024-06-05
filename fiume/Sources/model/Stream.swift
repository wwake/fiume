import Foundation

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

  func amount(at month: MonthYear) -> Money {
    if case let .month(startMonth) = first, month < startMonth {
      return Money(0)
    }
    if case let .age(person, age) = first {
      guard let birth = person.birth else { return Money(0) }
      let effectiveStart = birth.advanced(by: 12 * age)
      if month < effectiveStart { return Money(0) }
    }

    switch last {
    case .unchanged:
      return self.monthlyAmount

    case .month(let endMonth):
      if month > endMonth {
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
