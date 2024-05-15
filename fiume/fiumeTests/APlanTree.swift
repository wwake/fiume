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

	func test_plan_composite() {
		let tree1 = PlanLeaf(Stream("Income1", Dollar(1)))
		let tree2 = PlanLeaf(Stream("Income2", Dollar(2)))
		let tree3 = PlanLeaf(Stream("Income3", Dollar(3)))

		var parent = PlanComposite("parent")
		parent.append(tree1)
		parent.append(tree2)
		var grandparent = PlanComposite("gp")
		grandparent.append(parent)
		grandparent.append(tree3)

		XCTAssertEqual(grandparent.name, "gp")
		XCTAssertEqual(grandparent.children?.count, 2)
		XCTAssertEqual(parent.children?.count, 2)
		XCTAssertEqual(grandparent.net(10), 6)
	}
}
