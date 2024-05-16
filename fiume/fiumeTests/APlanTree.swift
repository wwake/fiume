@testable import fiume
import XCTest

final class APlanTree: XCTestCase {
	func makeLeaf(_ name: String, _ amount: Int) -> PlanLeaf {
		let stream = Stream(name, Money(amount))
		return PlanLeaf(stream)
	}

	func makeAndTree(_ name: String, _ children: [PlanTree]) -> PlanComposite {
		let result = PlanComposite(name)
		children.forEach {
			result.append($0)
		}
		return result
	}

	func makeOrTree(_ name: String, _ children: [PlanTree]) -> PlanAlternatives {
		let result = PlanAlternatives(name)
		children.forEach {
			result.append($0)
		}
		return result
	}

	func test_plan_leaf() throws {
		let leaf = makeLeaf("Income", 100)

		XCTAssertEqual(leaf.name, "Income")
		XCTAssertNil(leaf.children)
		XCTAssertEqual(leaf.net(3), Money(100))
	}

	func test_plan_composite() {
		let leaf1 = makeLeaf("Income1", 1)
		let leaf2 = makeLeaf("Income2", 2)
		let leaf3 = makeLeaf("Income3", 3)

		let parent = makeAndTree("parent", [leaf1, leaf2])
		let grandparent = makeAndTree("gp", [parent, leaf3])

		XCTAssertEqual(grandparent.name, "gp")
		XCTAssertEqual(grandparent.children?.count, 2)
		XCTAssertEqual(parent.children?.count, 2)
		XCTAssertEqual(grandparent.net(10), 6)
	}

	func test_plan_alternatives_net_is_max() {
		let leaf1 = makeLeaf("Income1", 1)
		let leaf2 = makeLeaf("Income2", 2)

		let parent = makeOrTree("alts", [leaf1, leaf2])

		XCTAssertEqual(parent.name, "alts")
		XCTAssertEqual(parent.children?.count, 2)
		XCTAssertEqual(parent.net(10), 2)
	}
}
