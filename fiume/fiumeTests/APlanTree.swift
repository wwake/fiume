@testable import fiume
import XCTest

final class APlanTree: XCTestCase {
	func makeLeaf(_ name: String, _ amount: Int, _ first: MonthNumber = 1, _ last: MonthNumber = 120) -> PlanLeaf {
		let stream = Stream(name, Money(amount), first: first, last: last)
		return PlanLeaf(stream)
	}

	func makeAndTree(_ name: String, _ children: [PlanTree]) -> PlanComposite {
		let result = PlanComposite.makeAndTree(name)
		children.forEach {
			result.append($0)
		}
		return result
	}

	func makeOrTree(_ name: String, _ children: [PlanTree]) -> PlanComposite {
		let result = PlanComposite.makeOrTree(name)
		children.forEach {
			result.append($0)
		}
		return result
	}

	func test_makes_a_leaf() throws {
		let sut = makeLeaf("Income", 100, 3, 12)

		XCTAssertEqual(sut.name, "Income")
		XCTAssertNil(sut.children)

		XCTAssertEqual(sut.net(2), Money(0))
		XCTAssertEqual(sut.net(3), Money(100))
		XCTAssertEqual(sut.net(13), Money(0))
	}

	func test_makes_a_composite() {
		let leaf1 = makeLeaf("Income1", 1)
		let leaf2 = makeLeaf("Income2", 2)
		let leaf3 = makeLeaf("Income3", 3)

		let parent = makeAndTree("parent", [leaf1, leaf2])
		let sut = makeAndTree("grandparent", [parent, leaf3])

		XCTAssertEqual(sut.name, "grandparent")
		XCTAssertEqual(sut.children?.count, 2)
		XCTAssertEqual(parent.children?.count, 2)
		XCTAssertEqual(sut.net(10), 6)
	}

	func test_net_of_alternatives_is_max() {
		let leaf1 = makeLeaf("Income1", 1)
		let leaf2 = makeLeaf("Income2", 2)

		let sut = makeOrTree("alts", [leaf1, leaf2])

		XCTAssertEqual(sut.name, "alts")
		XCTAssertEqual(sut.children?.count, 2)
		XCTAssertEqual(sut.net(10), 2)
	}

	func test_scenarios_for_stream() {
		let sut = makeLeaf("Income1", 1000, 1, 12)

		let result = sut.scenarios(ScenarioSet([Scenario(), Scenario()]))
		let array = Array(result)

		XCTAssertEqual(array.count, 2)
		XCTAssertEqual(array[0].net(12), Money(1000))
		XCTAssertEqual(array[0].net(13), Money(0))
		XCTAssertEqual(array[1].net(12), Money(1000))
		XCTAssertEqual(array[1].net(13), Money(0))
	}

	func test_scenarios_for_and_tree() {
		let leaf1 = makeLeaf("Income1", 1000, 1, 12)
		let leaf2 = makeLeaf("Income2", 2000, 6, 18)

		let sut = makeAndTree("parent", [leaf1, leaf2])

		let result = sut.scenarios(ScenarioSet([Scenario(), Scenario()]))
		let array = Array(result)

		XCTAssertEqual(array.count, 2)
		XCTAssertEqual(array[0].net(1), Money(1000))
		XCTAssertEqual(array[1].net(1), Money(1000))
		XCTAssertEqual(array[0].net(6), Money(3000))
		XCTAssertEqual(array[1].net(6), Money(3000))
		XCTAssertEqual(array[0].net(13), Money(2000))
		XCTAssertEqual(array[1].net(13), Money(2000))
	}

	func test_scenarios_for_or_tree() {
		let leaf1 = makeLeaf("Income1", 1000, 1, 12)
		let leaf2 = makeLeaf("Income2", 2000, 6, 18)

		let sut = makeOrTree("parent", [leaf1, leaf2])

		let result = sut.scenarios(ScenarioSet([Scenario()]))
		let array = Array(result)

		XCTAssertEqual(array.count, 2)
		let (x,y) = array[0].net(1) != 0 ? (array[0], array[1]) : (array[1], array[0])
		XCTAssertEqual(
			[x.net(1), x.net(6), x.net(13)],
			[Money(1000), Money(1000), Money(0)]
		)
		XCTAssertEqual(
			[y.net(1), y.net(6), y.net(13)],
			[Money(0), Money(2000), Money(2000)]
		)
	}

	func test_multiple_scenarios_for_or_tree() {
		let scenario1 = Scenario()
		let scenario2 = Scenario()
		scenario2.add(Stream("annuity", 500))

		let leaf1 = makeLeaf("Income1", 1000)
		let leaf2 = makeLeaf("Income2", 2000)

		let sut = makeOrTree("parent", [leaf1, leaf2])

		let result = sut.scenarios(ScenarioSet([scenario1, scenario2]))

		XCTAssertEqual(result.count, 4)
		XCTAssertTrue(result.contains { $0.net(1) == Money(1000)})
		XCTAssertTrue(result.contains { $0.net(1) == Money(2000)})
		XCTAssertTrue(result.contains { $0.net(1) == Money(1500)})
		XCTAssertTrue(result.contains { $0.net(1) == Money(2500)})
	}
}
