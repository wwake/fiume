import Foundation

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
  private var first: DateSpecifier
  private var last: DateSpecifier

  public var dates: DateRange {
    DateRange(first, last)
  }

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
    dates.includes(month, people) ? amount : Money(0)
  }

  public func update(overriddenBy leia: Leia) -> Leia {
    if self.name != leia.name { return self }

    let newFirst = self.first.update(using: leia.first)
    let newLast = self.last.update(using: leia.last)

    return Leia(id: leia.id, name: leia.name, amount: leia.amount, dates: DateRange(newFirst, newLast))
  }
}
