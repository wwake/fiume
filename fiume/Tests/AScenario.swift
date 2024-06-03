@testable import fiume
import XCTest

extension fiume.Stream: Equatable {
  public static func == (lhs: fiume.Stream, rhs: fiume.Stream) -> Bool {
    lhs.name == rhs.name && lhs.monthlyAmount == rhs.monthlyAmount && lhs.first == rhs.first && lhs.last == rhs.last
  }
}

final class AScenario: XCTestCase {
  private func makeStream(
    _ name: String,
    _ amount: Int,
    first: MonthNumber? = 1,
    last: MonthNumber? = nil
  ) -> fiume.Stream {
    let firstDate = first == nil ? DateSpecifier.unchanged : .month(first!)
    let lastDate = last == nil ? DateSpecifier.unchanged : .month(last!)
    return Stream(name, Money(amount), first: firstDate, last: lastDate)
  }

  private func makeScenario(_ streams: fiume.Stream...) -> Scenario {
    let result = Scenario("Scenario Name")
    streams.forEach {
      result.add($0)
    }
    return result
  }

  func test_makes_independent_copies() {
    let sut = makeScenario(makeStream("Income1", 1_000, first: 1, last: 12))

    let result = sut.copy("altered name")
    let stream2 = makeStream("Income2", 2_000, first: 1, last: 12)
    result.add(stream2)

    XCTAssertEqual(sut.net(1), Money(1_000))
    XCTAssertEqual(result.net(1), Money(3_000))
    XCTAssertEqual(result.name, "altered name")
  }

  func test_built_for_one_stream() {
    let sut = makeScenario(makeStream("Income1", 1_000, first: 1, last: 12))

    XCTAssertEqual(sut.net(12), Money(1_000))
    XCTAssertEqual(sut.net(13), Money(0))
  }

  func test_scenario_for_distinct_streams() {
    let sut = makeScenario(
      makeStream("Income1", 1_000, first: 1, last: 12),
      makeStream("Income2", 500, first: 10, last: nil)
    )

    XCTAssertEqual(sut.net(1), Money(1_000))
    XCTAssertEqual(sut.net(10), Money(1_500))
    XCTAssertEqual(sut.net(12), Money(1_500))
    XCTAssertEqual(sut.net(13), Money(500))
  }

  func test_scenario_for_merged_streams_with_last_date_unchanged() {
    let sut = makeScenario(
      makeStream("Income1", 1_000, first: 1, last: 12),
      makeStream("Income1", 500, first: 10, last: nil)
    )

    XCTAssertEqual(sut.net(1), Money(0))
    XCTAssertEqual(sut.net(10), Money(500))
    XCTAssertEqual(sut.net(12), Money(500))
    XCTAssertEqual(sut.net(13), Money(0))
  }

  func test_scenario_for_merged_streams_with_first_date_unchanged() {
    let sut = makeScenario(
      makeStream("Income1", 1_000, first: 2, last: 12),
      makeStream("Income1", 500, first: nil, last: 25)
    )

    XCTAssertEqual(sut.net(1), Money(0))
    XCTAssertEqual(sut.net(2), Money(500))
    XCTAssertEqual(sut.net(12), Money(500))
    XCTAssertEqual(sut.net(13), Money(500))
    XCTAssertEqual(sut.net(25), Money(500))
    XCTAssertEqual(sut.net(26), Money(0))
  }

  func test_salary_minus_expenses_creates_net_worth() throws {
    let sut = makeScenario(
      makeStream("Salary", Money(1_000)),
      makeStream("Expenses", Money(-900))
    )

    let result = sut.project(1...12)

    XCTAssertEqual(result.name, "Scenario Name")
    XCTAssertEqual(result.netWorthByMonth.last!.amount, Money(1_200))
  }
}
