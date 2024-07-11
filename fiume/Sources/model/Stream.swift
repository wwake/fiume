import Foundation

struct Stream: Identifiable, Codable {
  static var null: Stream {
    Stream("", 0, first: .unchanged, last: .unchanged)
  }

  var id = UUID()
  var name: String
  var amount: Money
  var first: DateSpecifier
  var last: DateSpecifier

  init(
    _ name: String,
    _ monthlyAmount: Money,
    first: DateSpecifier,
    last: DateSpecifier
  ) {
    self.name = name
    self.amount = monthlyAmount

    self.first = first

    self.last = last
  }

  var isNonNegative: Bool {
    amount >= 0
  }

  func amount(at month: MonthYear, people: People) -> Money {
    Self.amount(first: first, last: last, amount: amount, at: month, people: people)
  }

  static func amount(
    first: DateSpecifier,
    last: DateSpecifier,
    amount: Money,
    at month: MonthYear,
    people: People
  ) -> Money {
    switch first {
    case .unchanged:
      break

    case let .month(startMonth):
      if month < startMonth { return Money(0) }

    case let .age(id, age):
      guard let person = people.findById(id) else { return Money(0) }
      let birth = person.birth
      let effectiveStart = birth.advanced(byYears: age)
      if month < effectiveStart { return Money(0) }
    }

    switch last {
    case .unchanged:
      return amount

    case .month(let endMonth):
      if month > endMonth { return Money(0) }
      return amount

    case let .age(id, age):
      guard let person = people.findById(id) else { return Money(0) }
      let birth = person.birth
      let effectiveEnd = birth.advanced(byYears: age)
      if month >= effectiveEnd { return Money(0) }
      return amount
    }
  }

  func update(overriddenBy stream: Stream) -> Stream {
    if self.name != stream.name { return self }

    let newFirst = self.first.update(using: stream.first)
    let newLast = self.last.update(using: stream.last)

    return Stream(stream.name, stream.amount, first: newFirst, last: newLast)
  }
}
