@testable import fiume
import XCTest

final class APlanTree: XCTestCase {
    func test_plan_leaf() throws {
			let stream = Stream("Income", Dollar(100))
			let leaf = PlanLeaf(stream)

			XCTAssertEqual(leaf.name, "Income")
			XCTAssertNil(leaf.children)
			XCTAssertEqual(leaf.net(3), Dollar(100))
		}
}
