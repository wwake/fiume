@testable import fiume
import XCTest

extension fiume.Stream: Equatable {
  public static func == (lhs: fiume.Stream, rhs: fiume.Stream) -> Bool {
    lhs.name == rhs.name && lhs.monthlyAmount == rhs.monthlyAmount && lhs.first == rhs.first && lhs.last == rhs.last
  }
}

final class AScenario: XCTestCase {
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

  private func makeScenario(_ streams: fiume.Stream...) -> Scenario {
    let result = Scenario("Scenario Name", people: people)
    streams.forEach {
      result.add($0)
    }
    return result
  }

  func test_makes_independent_copies() {
    let sut = makeScenario(
      makeStream(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec)
    )

    let result = sut.copy("altered name")
    let stream2 = makeStream(name: "Income2", 2_000, first: 2024.jan, last: 2024.dec)
    result.add(stream2)

    XCTAssertEqual(sut.net(at: 2024.jan), Money(1_000))
    XCTAssertEqual(result.net(at: 2024.jan), Money(3_000))
    XCTAssertEqual(result.name, "altered name")
  }

  func test_built_for_one_stream() {
    let sut = makeScenario(
      makeStream(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec)
    )

    XCTAssertEqual(sut.net(at: 2024.dec), Money(1_000))
    XCTAssertEqual(sut.net(at: 2025.jan), Money(0))
  }

  func test_scenario_for_distinct_streams() {
    let sut = makeScenario(
      makeStream(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec),
      makeStream(name: "Income2", 500, first: DateSpecifier.month(2024.oct), last: DateSpecifier.unchanged)
    )

    XCTAssertEqual(sut.net(at: 2024.jan), Money(1_000))
    XCTAssertEqual(sut.net(at: 2024.oct), Money(1_500))
    XCTAssertEqual(sut.net(at: 2024.dec), Money(1_500))
    XCTAssertEqual(sut.net(at: 2025.jan), Money(500))
  }

  func test_scenario_for_merged_streams_with_last_date_unchanged() {
    let sut = makeScenario(
      makeStream(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec),
      makeStream(name: "Income1", 500, first: DateSpecifier.month(2024.oct), last: DateSpecifier.unchanged)
    )

    XCTAssertEqual(sut.net(at: 2024.jan), Money(0))
    XCTAssertEqual(sut.net(at: 2024.oct), Money(500))
    XCTAssertEqual(sut.net(at: 2024.dec), Money(500))
    XCTAssertEqual(sut.net(at: 2025.jan), Money(0))
  }

  func test_scenario_for_merged_streams_with_first_date_unchanged() {
    let sut = makeScenario(
      makeStream(name: "Income1", 1_000, first: 2024.feb, last: 2024.dec),
      makeStream(name: "Income1", 500, first: DateSpecifier.unchanged, last: DateSpecifier.month(2026.jan))
    )

    XCTAssertEqual(sut.net(at: 2024.jan), Money(0))
    XCTAssertEqual(sut.net(at: 2024.feb), Money(500))
    XCTAssertEqual(sut.net(at: 2024.dec), Money(500))
    XCTAssertEqual(sut.net(at: 2025.jan), Money(500))
    XCTAssertEqual(sut.net(at: 2026.jan), Money(500))
    XCTAssertEqual(sut.net(at: 2026.feb), Money(0))
  }

  func test_salary_minus_expenses_creates_net_worth() throws {
    let sut = makeScenario(
      makeStream(name: "Salary", 1_000, first: DateSpecifier.unchanged, last: DateSpecifier.unchanged),
      makeStream(name: "Expenses", -900, first: DateSpecifier.unchanged, last: DateSpecifier.unchanged)
    )

    let result = sut.netWorth(2024.jan...2024.dec)

    XCTAssertEqual(result.name, "Scenario Name")
    XCTAssertEqual(result.netWorthByMonth.last!.amount, Money(1_200))
  }
}
