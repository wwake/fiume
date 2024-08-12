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
    Leia(name: name, amount: .money(amount), dates: DateRange(.month(first), .month(last)), leiaType: .income)
  }

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: DateSpecifier,
    last: DateSpecifier
  ) -> Leia {
    Leia(name: name, amount: .money(amount), dates: DateRange(first, last), leiaType: .income)
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

  @Test
  func knows_its_sign() {
    #expect(makeLeia(5, first: 2020.jan, last: 2020.dec).isNonNegative)
    #expect(makeLeia(0, first: 2021.jan, last: 2021.mar).isNonNegative)
    #expect(!makeLeia(-5, first: 2020.oct, last: 2020.dec).isNonNegative)
  }
}
