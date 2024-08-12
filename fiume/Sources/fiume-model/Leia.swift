import Foundation

// Leia = Liability/Expense/Income/Asset (ie Stream or Pool)
//

public enum LeiaType: Codable {
  case
    asset,
    liability,
    income,
    expense

  public func signed(_ money: Money) -> Money {
    switch self {
    case .asset, .income:
      return money

    case .liability, .expense:
      return -money
    }
  }
}

public struct Leia: Identifiable, Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
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
  private var first: DateSpecifier
  private var last: DateSpecifier
  private var amountSpec: Amount
  private var leiaType: LeiaType

  public var dates: DateRange {
    DateRange(first, last)
  }

  public var amount: Amount {
    amountSpec
  }

  public var type: LeiaType {
    leiaType
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
    return type.signed(amount.value(at: month, people, scenario))
  }
}
