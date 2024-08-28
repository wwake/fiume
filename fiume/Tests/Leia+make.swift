@testable import fiume
import fiume_model

public func makeLeia(
  name: String = "Sample",
  _ amount: Int,
  first: MonthYear,
  last: MonthYear,
  _ leiaType: LeiaType
) -> Leia {
  Leia(
    name: name,
    amount: .money(amount),
    dates: DateRange(.month(first), .month(last)),
    type: leiaType,
    growth: PercentAssumption.flatGrowth
  )
}

public func makeLeia(
  name: String = "Sample",
  _ amount: Int,
  first: DateSpecifier,
  last: DateSpecifier,
  leiaType: LeiaType = .income
) -> Leia {
  Leia(
    name: name,
    amount: .money(amount),
    dates: DateRange(first, last),
    type: leiaType,
    growth: PercentAssumption.flatGrowth
  )
}

public func makeLeia(
  name: String = "Sample",
  _ amount: Int,
  dates: DateRange = DateRange.always,
  leiaType: LeiaType = .income
) -> Leia {
  Leia(
    name: name,
    amount: .money(amount),
    dates: dates,
    type: leiaType,
    growth: PercentAssumption.flatGrowth
  )
}

public func makeLeia(_ name: String, _ amount: Int) -> Leia {
  Leia(
    name: name,
    amount: .money(amount),
    dates: DateRange(.month(2024.jan), .unchanged),
    type: .income,
    growth: PercentAssumption.flatGrowth
  )
}
