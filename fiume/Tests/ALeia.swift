@testable import fiume
import Testing

struct ALeia {
  private let people = People()

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: MonthYear,
    last: MonthYear
  ) -> fiume.Leia {
    Leia(name: name, amount: Money(amount), first: DateSpecifier.month(first), last: DateSpecifier.month(last))
  }

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: DateSpecifier,
    last: DateSpecifier
  ) -> fiume.Leia {
    Leia(name: name, amount: Money(amount), first: first, last: last)
  }

  @Test
  func determines_amount_outside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct)
    #expect(sut.amount(at: 2019.dec, people: people) == Money(0))
    #expect(sut.amount(at: 2020.nov, people: people) == Money(0))
  }

  @Test
  func determines_amount_inside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct)
    #expect(sut.amount(at: 2020.jan, people: people) == Money(100))
    #expect(sut.amount(at: 2020.oct, people: people) == Money(100))
  }

  @Test
  func starts_month_at_1_when_unspecified() {
    let sut = makeLeia(100, first: DateSpecifier.unchanged, last: DateSpecifier.month(2020.feb))
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

  @Test
  func can_start_at_an_age() {
    let person = Person(name: "Bob", birth: 1970.jan, death: nil)
    people.add(person)
    let age = DateSpecifier.age(person.id, 40)
    let sut = makeLeia(name: "Annuity", 500, first: age, last: .unchanged)
    #expect(sut.amount(at: 2009.dec, people: people) == Money(0))
    #expect(sut.amount(at: 2010.jan, people: people) == Money(500))
  }

  @Test
  func can_end_at_an_age() {
    let person = Person(name: "Bob", birth: 1970.jan, death: nil)
    people.add(person)
    let age = DateSpecifier.age(person.id, 40)
    let sut = makeLeia(name: "Annuity", 500, first: .unchanged, last: age)
    #expect(sut.amount(at: 2009.dec, people: people) == Money(500))
    #expect(sut.amount(at: 2010.jan, people: people) == Money(0))
  }
}
