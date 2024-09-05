import Foundation

// Leia = Liability/Expense/Income/Asset (ie Stream or Pool)
//

public enum LeiaType: Codable, CaseIterable {
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

  public var frequency: String {
    switch self {
    case .asset, .liability:
      return ""

    case .income, .expense:
      return "/mo"
    }
  }
}

public struct Leia: Identifiable, Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case dates
    case amount = "amountSpec"
    case type = "leiaType"
    case growth
  }

  public static var null: Leia {
    Leia(
      id: UUID(),
      name: "",
      amount: .money(0),
      dates: DateRange.always,
      type: .income,
      growth: Assumption.defaultGrowth
    )
  }

  public var id: UUID
  public var name: String

  public private(set) var dates: DateRange

  public private(set) var amount: Amount
  public private(set) var type: LeiaType

  public var growth: String?

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

    self.dates = dates

    self.type = type
    self.growth = growth
  }

  public func signedAmount(
    start: MonthYear? = nil,
    at month: MonthYear,
    scenario: Scenario
  ) -> Money {
    guard dates.includes(month) else {
      return Money(0)
    }

    let effectiveStart = dates.first == DateSpecifier.unchanged ? start : dates.first.effectiveStart

    return type.signed(amount.value(
      monthlyInterest: Assumptions.shared.findMonthlyRate(growth),
      start: effectiveStart,
      at: month,
      scenario
    ))
  }
}
