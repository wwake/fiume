@testable import fiume
import XCTest

final class AScenario: XCTestCase {
  private func makeStream(_ name: String, _ amount: Int, first: MonthNumber = 1, last: MonthNumber? = nil) -> fiume.Stream {
    let dateSpec = last == nil ? DateSpecifier.unspecified : .month(last!)
    return Stream(name, Money(amount), first: first, last: dateSpec)
  }

  private func makeScenario() -> Scenario {
    Scenario()
  }

	func test_makes_independent_copies() {
		let sut = makeScenario()
		let stream = makeStream("Income1", 1_000, first: 1, last: 12)
		sut.add(stream)

		let result = sut.copy()
		let stream2 = makeStream("Income2", 2_000, first: 1, last: 12)
		result.add(stream2)

		XCTAssertEqual(sut.net(1), Money(1_000))
		XCTAssertEqual(result.net(1), Money(3_000))
	}

	func test_built_for_one_stream() {
		let sut = makeScenario()
		let stream = makeStream("Income1", 1_000, first: 1, last: 12)

		sut.add(stream)

		XCTAssertEqual(sut.net(12), Money(1_000))
		XCTAssertEqual(sut.net(13), Money(0))
	}

	func test_built_for_multiple_streams() {
		let sut = makeScenario()
		let stream1 = makeStream("Income1", 1_000, first: 1, last: 12)
		let stream2 = makeStream("Income2", 500, first: 10, last: nil)

		sut.add(stream1)
		sut.add(stream2)

		XCTAssertEqual(sut.net(1), Money(1_000))
		XCTAssertEqual(sut.net(10), Money(1_500))
		XCTAssertEqual(sut.net(12), Money(1_500))
		XCTAssertEqual(sut.net(13), Money(500))
	}

	func test_built_for_merged_streams() {
		let sut = makeScenario()
		let stream1 = makeStream("Income1", 1_000, first: 1, last: 12)
		let stream2 = makeStream("Income1", 500, first: 10, last: nil)

		sut.add(stream1)
		sut.add(stream2)

		XCTAssertEqual(sut.net(1), Money(0))
		XCTAssertEqual(sut.net(10), Money(500))
		XCTAssertEqual(sut.net(12), Money(500))
		XCTAssertEqual(sut.net(13), Money(0))
	}

  func test_salary_minus_expenses_creates_net_worth() throws {
    let sut = makeScenario()
    sut.add(makeStream("Salary", Money(1_000)))
    sut.add(makeStream("Expenses", Money(-900)))

    let result = sut.project(1...12)

    XCTAssertEqual(result.netWorthByMonth.last!.amount, Money(1_200))
  }
}
