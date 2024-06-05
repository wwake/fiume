@testable import fiume
import XCTest

final class AStream: XCTestCase {
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
    let sut = makeStream(100, first: MonthYear(.jan, 2020), last: MonthYear(.oct, 2020))
    XCTAssertEqual(sut.amount(of: MonthYear(.dec, 2019), month: 0), Money(0))
    XCTAssertEqual(sut.amount(of: MonthYear(.nov, 2020), month: 11), Money(0))
  }

  func test_determines_amount_inside_month_year_date_range() throws {
    let sut = makeStream(100, first: MonthYear(.jan, 2020), last: MonthYear(.oct, 2020))
    XCTAssertEqual(sut.amount(of: MonthYear(.jan, 2020), month: 1), Money(100))
    XCTAssertEqual(sut.amount(of: MonthYear(.oct, 2020), month: 10), Money(100))
  }

  func test_determines_amount_inside_date_range() throws {
    let sut = makeStream(100, first: MonthYear(.feb, 2020), last: MonthYear(.oct, 2020))
    XCTAssertEqual(sut.amount(of: MonthYear(.feb, 2020), month: 1), Money(100))
    XCTAssertEqual(sut.amount(of: MonthYear(.oct, 2020), month: 10), Money(100))
  }

  func test_determines_amount_outside_date_range() throws {
    let sut = makeStream(100, first: MonthYear(.mar, 2020), last: MonthYear(.nov, 2020))
    XCTAssertEqual(sut.amount(of: MonthYear(.feb, 2020), month: 0), Money(0))
    XCTAssertEqual(sut.amount(of: MonthYear(.dec, 2020), month: 12), Money(0))
  }

  func test_month_starts_at_1_when_unspecified() {
    let sut = makeStream(100, first: DateSpecifier.unchanged, last: DateSpecifier.month(MonthYear(.feb, 2020)))
    XCTAssertEqual(sut.amount(of: MonthYear(.jan, 2020), month: 1), Money(100))
  }

  func test_merge_when_values_change() {
    let stream1 = makeStream(500, first: MonthYear(.jan, 2020), last: MonthYear(.oct, 2020))
    let stream2 = makeStream(1_000, first: MonthYear(.may, 2020), last: MonthYear(.dec, 2020))
    let sut = stream1.update(overriddenBy: stream2)
    XCTAssertEqual(sut, makeStream(1_000, first: MonthYear(.may, 2020), last: MonthYear(.dec, 2020)))
  }

  func test_merge_when_values_are_omitted() {
    let stream1 = makeStream(name: "Salary", 500, first: MonthYear(.jan, 2030), last: MonthYear(.dec, 2030))
    let stream2 = makeStream(
      name: "Salary",
      500,
      first: DateSpecifier.month(MonthYear(.may, 2030)),
      last: DateSpecifier.unchanged
    )

    let sut = stream1.update(overriddenBy: stream2)

    XCTAssertEqual(sut, makeStream(name: "Salary", 500, first: MonthYear(.may, 2030), last: MonthYear(.dec, 2030)))
  }

  func test_dontMergeWhenNamesDiffer() {
    let stream1 = makeStream(name: "Salary", 500, first: MonthYear(.jan, 2020), last: MonthYear(.dec, 2020))
    let stream2 = makeStream(name: "Different", 1_500, first: MonthYear(.may, 2020), last: MonthYear(.dec, 2021))
    let merged = stream1.update(overriddenBy: stream2)
    XCTAssertEqual(merged, makeStream(name: "Salary", 500, first: MonthYear(.jan, 2020), last: MonthYear(.dec, 2020)))
  }

  func test_knows_its_sign() {
    XCTAssertTrue(makeStream(5, first: MonthYear(.jan, 2020), last: MonthYear(.dec, 2020)).isNonNegative)
    XCTAssertTrue(makeStream(0, first: MonthYear(.jan, 2021), last: MonthYear(.mar, 2021)).isNonNegative)
    XCTAssertFalse(makeStream(-5, first: MonthYear(.oct, 2020), last: MonthYear(.dec, 2020)).isNonNegative)
  }
}
