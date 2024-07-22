import Foundation

public struct DateRange {
  public var first: DateSpecifier
  public var last: DateSpecifier

  public static var null = DateRange(.unchanged, .unchanged)

  public init(_ first: DateSpecifier, _ last: DateSpecifier) {
    self.first = first
    self.last = last
  }
}

// Leia = Liability/Expense/Income/Asset (ie Stream or Pool)
//
public struct Leia: Identifiable, Codable {
  public enum CodingKeys: String, CodingKey {
    case id
    case name
    case amount
    case first
    case last
  }

  public static var null: Leia {
    Leia(id: UUID(), name: "", amount: 0, dates: DateRange.null)
  }

  public var id: UUID
  public var name: String
  public var amount: Money
  public var first: DateSpecifier
  public var last: DateSpecifier

  public init(
    id: UUID = UUID(),
    name: String,
    amount: Money,
    dates: DateRange
  ) {
    self.id = id
    self.name = name
    self.amount = amount

    self.first = dates.first
    self.last = dates.last
  }

  public var isNonNegative: Bool {
    amount >= 0
  }

  public func amount(at month: MonthYear, people: People) -> Money {
    Self.amount(dates: DateRange(first, last), amount: amount, at: month, people: people)
  }

  public static func amount(
    dates: DateRange,
    amount: Money,
    at month: MonthYear,
    people: People
  ) -> Money {
    switch dates.first {
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

    switch dates.last {
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

  public func update(overriddenBy leia: Leia) -> Leia {
    if self.name != leia.name { return self }

    let newFirst = self.first.update(using: leia.first)
    let newLast = self.last.update(using: leia.last)

    return Leia(id: leia.id, name: leia.name, amount: leia.amount, dates: DateRange(newFirst, newLast))
  }
}
