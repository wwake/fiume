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

  public var name: String {
    switch self {
    case .asset:
      return "Asset"

    case .liability:
      return "Liability"

    case .income:
      return "Income"

    case .expense:
      return "Expense"
    }
  }
}

public struct Leia: Identifiable, Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case first
    case last
    case dates
    case amount = "amountSpec"
    case type = "leiaType"
    case growth
  }

  public static var null: Leia {
    Leia(id: UUID(), name: "", amount: .money(0), dates: DateRange.always, type: .income, growth: Assumption.flatGrowth)
  }

  public var id: UUID
  public var name: String
  private var first: DateSpecifier
  private var last: DateSpecifier

  public var dates: DateRange?

  public private(set) var amount: Amount
  public private(set) var type: LeiaType

  public var growth: String?

  public var dates_: DateRange {
    dates ?? DateRange(first, last)
  }

  public init(
    id: UUID = UUID(),
    name: String,
    amount: Amount,
    dates: DateRange,
    type: LeiaType,
    growth: String?
  ) {
    self.id = id
    self.name = name
    self.amount = amount

    self.first = dates.first
    self.last = dates.last

    self.dates = dates

    self.type = type
    self.growth = growth
  }

  public func signedAmount(start: MonthYear? = nil, at month: MonthYear, people: People, scenario: Scenario) -> Money {
    guard dates_.includes(month, people) else {
      return Money(0)
    }

    return type.signed(amount.value(monthlyInterest: 0.0, start: start, at: month, people, scenario))
  }
}
