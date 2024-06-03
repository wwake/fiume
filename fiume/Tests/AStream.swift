@testable import fiume
import XCTest

final class AStream: XCTestCase {
  private func makeStream(
    name: String = "Sample",
    _ amount: Int,
    first: MonthNumber?,
    last: MonthNumber?
  ) -> fiume.Stream {
    let firstDateSpec = first == nil ? DateSpecifier.unchanged : .month(first!)
    let lastDateSpec = last == nil ? DateSpecifier.unchanged : .month(last!)
    return Stream(name, Money(amount), first: firstDateSpec, last: lastDateSpec)
  }

  func test_determines_amount_inside_date_range() throws {
    let sut = makeStream(100, first: 1, last: 10)
    XCTAssertEqual(sut.amount(month: 1), Money(100))
    XCTAssertEqual(sut.amount(month: 10), Money(100))
  }

  func test_determines_amount_outside_date_range() throws {
    let sut = makeStream(100, first: 1, last: 10)
    XCTAssertEqual(sut.amount(month: 0), Money(0))
    XCTAssertEqual(sut.amount(month: 12), Money(0))
  }

  func test_month_starts_at_1_when_unspecified() {
    let sut = makeStream(100, first: nil, last: 10)
    XCTAssertEqual(sut.amount(month: 1), Money(100))
  }

  func test_merge_when_values_change() {
    let stream1 = makeStream(500, first: 1, last: 10)
    let stream2 = makeStream(1_000, first: 5, last: 20)
    let sut = stream1.update(overriddenBy: stream2)
    XCTAssertEqual(sut, makeStream(1_000, first: 5, last: 20))
  }

  func test_merge_when_values_are_omitted() {
    let stream1 = makeStream(name: "Salary", 500, first: 1, last: 12)
    let stream2 = makeStream(name: "Salary", 500, first: 5, last: nil)

    let sut = stream1.update(overriddenBy: stream2)

    XCTAssertEqual(sut, makeStream(name: "Salary", 500, first: 5, last: 12))
  }

  func test_dontMergeWhenNamesDiffer() {
    let stream1 = makeStream(name: "Salary", 500, first: 1, last: 12)
    let stream2 = makeStream(name: "Different", 1_500, first: 5, last: 24)
    let merged = stream1.update(overriddenBy: stream2)
    XCTAssertEqual(merged, makeStream(name: "Salary", 500, first: 1, last: 12))
  }

  func test_knows_its_sign() {
    XCTAssertTrue(makeStream(5, first: 1, last: 12).isNonNegative)
    XCTAssertTrue(makeStream(0, first: 1, last: 3).isNonNegative)
    XCTAssertFalse(makeStream(-5, first: 10, last: 20).isNonNegative)
  }
}
