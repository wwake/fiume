import Foundation

struct Stream: Identifiable, Codable {
  var id = UUID()
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
    switch first {
    case .unchanged:
      break

    case let .month(startMonth):
      if month < startMonth { return Money(0) }

    case let .age(person, age):
      let effectiveStart = person.birth.advanced(by: 12 * age)
      if month < effectiveStart { return Money(0) }
    }

    switch last {
    case .unchanged:
      return self.monthlyAmount

    case .month(let endMonth):
      if month > endMonth { return Money(0) }
      return self.monthlyAmount

    case let .age(person, age):
      let effectiveEnd = person.birth.advanced(by: 12 * age)
      if month >= effectiveEnd { return Money(0) }
      return self.monthlyAmount
    }
  }

  func update(overriddenBy stream: Stream) -> Stream {
    if self.name != stream.name { return self }

    let newFirst = self.first.update(using: stream.first)
    let newLast = self.last.update(using: stream.last)

    return Stream(stream.name, stream.monthlyAmount, first: newFirst, last: newLast)
  }
}
