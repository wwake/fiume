@testable import fiume
import XCTest

final class AStream: XCTestCase {
  private let people = People()

  private func makeStream(
    name: String = "Sample",
    _ amount: Int,
    first: MonthYear,
    last: MonthYear
  ) -> fiume.Stream {
    Stream(name, Money(amount), first: DateSpecifier.month(first), last: DateSpecifier.month(last))
  }

  private func makeStream(
    name: String = "Sample",
    _ amount: Int,
    first: DateSpecifier,
    last: DateSpecifier
  ) -> fiume.Stream {
    Stream(name, Money(amount), first: first, last: last)
  }

  func test_determines_amount_outside_month_year_date_range() throws {
    let sut = makeStream(100, first: 2020.jan, last: 2020.oct)
    XCTAssertEqual(sut.amount(at: 2019.dec, people: people), Money(0))
    XCTAssertEqual(sut.amount(at: 2020.nov, people: people), Money(0))
  }

  func test_determines_amount_inside_month_year_date_range() throws {
    let sut = makeStream(100, first: 2020.jan, last: 2020.oct)
    XCTAssertEqual(sut.amount(at: 2020.jan, people: people), Money(100))
    XCTAssertEqual(sut.amount(at: 2020.oct, people: people), Money(100))
  }

  func test_month_starts_at_1_when_unspecified() {
    let sut = makeStream(100, first: DateSpecifier.unchanged, last: DateSpecifier.month(2020.feb))
    XCTAssertEqual(sut.amount(at: 2020.jan, people: people), Money(100))
  }

  func test_merge_when_values_change() {
    let stream1 = makeStream(500, first: 2020.jan, last: 2020.oct)
    let stream2 = makeStream(1_000, first: 2020.may, last: 2020.dec)
    let sut = stream1.update(overriddenBy: stream2)
    XCTAssertEqual(sut, makeStream(1_000, first: 2020.may, last: 2020.dec))
  }

  func test_merge_when_values_are_omitted() {
    let stream1 = makeStream(name: "Salary", 500, first: 2030.jan, last: MonthYear(.dec, 2030))
    let stream2 = makeStream(
      name: "Salary",
      500,
      first: DateSpecifier.month(2030.may),
      last: DateSpecifier.unchanged
    )

    let sut = stream1.update(overriddenBy: stream2)

    XCTAssertEqual(sut, makeStream(name: "Salary", 500, first: 2030.may, last: MonthYear(.dec, 2030)))
  }

  func test_dontMergeWhenNamesDiffer() {
    let stream1 = makeStream(name: "Salary", 500, first: 2020.jan, last: 2020.dec)
    let stream2 = makeStream(name: "Different", 1_500, first: 2020.may, last: MonthYear(.dec, 2021))
    let merged = stream1.update(overriddenBy: stream2)
    XCTAssertEqual(merged, makeStream(name: "Salary", 500, first: 2020.jan, last: 2020.dec))
  }

  func test_knows_its_sign() {
    XCTAssertTrue(makeStream(5, first: 2020.jan, last: 2020.dec).isNonNegative)
    XCTAssertTrue(makeStream(0, first: MonthYear(.jan, 2021), last: 2021.mar).isNonNegative)
    XCTAssertFalse(makeStream(-5, first: 2020.oct, last: 2020.dec).isNonNegative)
  }

  func test_doesnt_pay_by_starting_age_if_birthdate_unknown() {
    let person = Person(name: "Bob", birth: 1980.jan, death: nil)
    people.add(person)
    let age = DateSpecifier.age(person.id, 40)
    let sut = makeStream(name: "Annuity", 500, first: age, last: .unchanged)
    XCTAssertEqual(sut.amount(at: 2009.dec, people: people), Money(0))
    XCTAssertEqual(sut.amount(at: 2010.jan, people: people), Money(0))
  }

  func test_can_start_at_an_age() {
    let person = Person(name: "Bob", birth: 1970.jan, death: nil)
    people.add(person)
    let age = DateSpecifier.age(person.id, 40)
    let sut = makeStream(name: "Annuity", 500, first: age, last: .unchanged)
    XCTAssertEqual(sut.amount(at: 2009.dec, people: people), Money(0))
    XCTAssertEqual(sut.amount(at: 2010.jan, people: people), Money(500))
  }

  func test_can_end_at_an_age() {
    let person = Person(name: "Bob", birth: 1970.jan, death: nil)
    people.add(person)
    let age = DateSpecifier.age(person.id, 40)
    let sut = makeStream(name: "Annuity", 500, first: .unchanged, last: age)
    XCTAssertEqual(sut.amount(at: 2009.dec, people: people), Money(500))
    XCTAssertEqual(sut.amount(at: 2010.jan, people: people), Money(0))
  }
}
