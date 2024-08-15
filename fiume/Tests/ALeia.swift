@testable import fiume
import fiume_model
import Testing

struct ALeia {
  private let people = People()

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: MonthYear,
    last: MonthYear
  ) -> Leia {
    Leia(
      name: name,
      amount: .money(amount),
      dates: DateRange(.month(first), .month(last)),
      type: .income,
      growth: Assumption.flatGrowth
    )
  }

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: DateSpecifier,
    last: DateSpecifier
  ) -> Leia {
    Leia(name: name, amount: .money(amount), dates: DateRange(first, last), type: .income, growth: Assumption.flatGrowth)
  }

  @Test
  func returns_zero_outside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct)
    #expect(sut.signedAmount(at: 2019.dec, people: people) == Money(0))
  }

  @Test
  func returns_amount_inside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct)
    #expect(sut.signedAmount(at: 2020.jan, people: people) == Money(100))
  }
}
