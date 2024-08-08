import Foundation

// Leia = Liability/Expense/Income/Asset (ie Stream or Pool)
//

public enum LeiaType: Codable {
  case
    asset,
    liability,
    income,
    expense,
    unspecified

  public func signed(_ money: Money) -> Money {
    switch self {
    case .asset, .income:
      return abs(money)

    case .liability, .expense:
      return -abs(money)

    case .unspecified:
      return Money(0)
    }
  }
}

public struct Leia: Identifiable, Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case amount_original = "amount"  // original JSON field name
    case first
    case last
    case amountSpec
    case leiaType
  }

  public static var null: Leia {
    Leia(id: UUID(), name: "", amount: .money(0), dates: DateRange.always, leiaType: .asset)
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
    leiaType: LeiaType?
  ) {
    self.id = id
    self.name = name
    self.amount_original = 0
    self.amountSpec = amount

    self.first = dates.first
    self.last = dates.last

    self.leiaType = leiaType
  }

  public var isNonNegative: Bool {
    amount.isNonNegative
  }

  public func amount(at month: MonthYear, people: People, scenario: Scenario? = nil) -> Money {
    guard dates.includes(month, people) else {
      return Money(0)
    }
    return type.signed(amount.value(at: month, scenario))
  }
}
