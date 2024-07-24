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
    Leia(name: name, amount: .amount(amount), dates: DateRange(.month(first), .month(last)))
  }

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: DateSpecifier,
    last: DateSpecifier
  ) -> Leia {
    Leia(name: name, amount: .amount(amount), dates: DateRange(first, last))
  }

  @Test
  func returns_zero_outside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct)
    #expect(sut.amount(at: 2019.dec, people: people) == Money(0))
  }

  @Test
  func returns_amount_inside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct)
    #expect(sut.amount(at: 2020.jan, people: people) == Money(100))
  }

  @Test
  func merges_when_values_change() {
    let stream1 = makeLeia(500, first: 2020.jan, last: 2020.oct)
    let stream2 = makeLeia(1_000, first: 2020.may, last: 2020.dec)
    let sut = stream1.update(overriddenBy: stream2)
    #expect(sut == makeLeia(1_000, first: 2020.may, last: 2020.dec))
  }

  @Test
  func merges_when_values_are_omitted() {
    let stream1 = makeLeia(name: "Salary", 500, first: 2030.jan, last: MonthYear(.dec, 2030))
    let stream2 = makeLeia(
      name: "Salary",
      500,
      first: DateSpecifier.month(2030.may),
      last: DateSpecifier.unchanged
    )

    let sut = stream1.update(overriddenBy: stream2)

    #expect(sut == makeLeia(name: "Salary", 500, first: 2030.may, last: MonthYear(.dec, 2030)))
  }

  @Test
  func doesnt_merge_when_names_differ() {
    let stream1 = makeLeia(name: "Salary", 500, first: 2020.jan, last: 2020.dec)
    let stream2 = makeLeia(name: "Different", 1_500, first: 2020.may, last: 2021.dec)
    let merged = stream1.update(overriddenBy: stream2)
    #expect(merged == makeLeia(name: "Salary", 500, first: 2020.jan, last: 2020.dec))
  }

  @Test
  func knows_its_sign() {
    #expect(makeLeia(5, first: 2020.jan, last: 2020.dec).isNonNegative)
    #expect(makeLeia(0, first: 2021.jan, last: 2021.mar).isNonNegative)
    #expect(!makeLeia(-5, first: 2020.oct, last: 2020.dec).isNonNegative)
  }
}
