import Foundation

// Leia = Liability/Expense/Income/Asset (ie Stream or Pool)
//
public struct Leia: Identifiable, Codable {
  public enum CodingKeys: String, CodingKey {
    case id
    case name
    case amount_original = "amount"  // original JSON field name
    case first
    case last
    case amountSpec
  }

  public static var null: Leia {
    Leia(id: UUID(), name: "", amount: 0, dates: DateRange.null)
  }

  public var id: UUID
  public var name: String
  private var amount_original: Money
  private var first: DateSpecifier
  private var last: DateSpecifier

  public var dates: DateRange {
    DateRange(first, last)
  }

  private var amountSpec: MoneySpecifier?

  public var amount: MoneySpecifier {
    guard let result = amountSpec else {
      return MoneySpecifier.amount(amount_original)
    }
    return result
  }

  public init(
    id: UUID = UUID(),
    name: String,
    amount: Money,
    dates: DateRange
  ) {
    self.id = id
    self.name = name

    self.amount_original = amount
    self.amountSpec = .amount(amount)

    self.first = dates.first
    self.last = dates.last
  }

  public init(
    id: UUID = UUID(),
    name: String,
    amount: MoneySpecifier,
    dates: DateRange
  ) {
    self.id = id
    self.name = name
    self.amount_original = amount.value()
    self.amountSpec = amount

    self.first = dates.first
    self.last = dates.last
  }

  public var isNonNegative: Bool {
    amount.value() >= 0
  }

  public func amount(at month: MonthYear, people: People) -> Money {
    dates.includes(month, people) ? amount.value() : Money(0)
  }

  public func update(overriddenBy leia: Leia) -> Leia {
    if self.name != leia.name { return self }

    let newFirst = self.first.update(using: leia.first)
    let newLast = self.last.update(using: leia.last)

    return Leia(id: leia.id, name: leia.name, amount: leia.amount, dates: DateRange(newFirst, newLast))
  }
}
