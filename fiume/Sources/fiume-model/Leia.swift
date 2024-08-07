import Foundation

// Leia = Liability/Expense/Income/Asset (ie Stream or Pool)
//
public struct Leia: Identifiable, Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case amount_original = "amount"  // original JSON field name
    case first
    case last
    case amountSpec
  }

  public enum LeiaType {
    case
      asset,
      liability,
      income,
      expense,
      unspecified
  }

  public static var null: Leia {
    Leia(id: UUID(), name: "", amount: .money(0), dates: DateRange.null, leiaType: .asset)
  }

  public var id: UUID
  public var name: String
  private var amount_original: Money
  private var first: DateSpecifier
  private var last: DateSpecifier
  private var amountSpec: Amount?
  private var leiaType: LeiaType?

  public var dates: DateRange {
    DateRange(first, last)
  }

  public var amount: Amount {
    guard let result = amountSpec else {
      return Amount(amount_original)
    }
    return result
  }

  public var type: LeiaType {
    leiaType ?? .unspecified
  }

  public init(
    id: UUID = UUID(),
    name: String,
    amount: Amount,
    dates: DateRange,
    leiaType: LeiaType
  ) {
    self.id = id
    self.name = name
    self.amount_original = 0
    self.amountSpec = amount

    self.first = dates.first
    self.last = dates.last
  }

  public var isNonNegative: Bool {
    amount.isNonNegative
  }

  public func amount(at month: MonthYear, people: People, scenario: Scenario? = nil) -> Money {
    guard dates.includes(month, people) else {
      return Money(0)
    }
    return amount.value(at: month, scenario)
  }

  public func update(overriddenBy leia: Leia) -> Leia {
    if self.name != leia.name { return self }

    let newFirst = self.first.update(using: leia.first)
    let newLast = self.last.update(using: leia.last)

    return Leia(
      id: leia.id,
      name: leia.name,
      amount: leia.amount,
      dates: DateRange(newFirst, newLast),
      leiaType: leia.type
    )
  }
}
