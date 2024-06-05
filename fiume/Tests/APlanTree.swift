@testable import fiume
import XCTest

final class APlanTree: XCTestCase {
  private func makeStream(_ name: String, _ amount: Int) -> fiume.Stream {
    Stream(name, Money(amount), first: .month(MonthYear(.jan, 2024)), last: .unchanged)
  }

  private func makeLeaf(
    _ name: String,
    _ amount: Int,
    _ first: MonthYear = MonthYear(.jan, 2024),
    _ last: MonthYear = MonthYear(.dec, 2034)
  ) -> PlanLeaf {
    let stream = Stream(name, Money(amount), first: .month(first), last: .month(last))
    return PlanLeaf(stream)
  }

  private func makeAndTree(_ name: String, _ children: [PlanTree]) -> PlanComposite {
    let result = AndTree(name)
    children.forEach {
      result.append($0)
    }
    return result
  }

  private func makeOrTree(_ name: String, _ children: [PlanTree]) -> PlanComposite {
    let result = OrTree(name)
    children.forEach {
      result.append($0)
    }
    return result
  }

  func test_makes_a_leaf() throws {
    let sut = makeLeaf("Income", 100, MonthYear(.mar, 2024), MonthYear(.dec, 2024))

    XCTAssertEqual(sut.name, "Income")
    XCTAssertNil(sut.children)
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
  }

  func test_net_of_alternatives_is_max() {
    let leaf1 = makeLeaf("Income1", 1)
    let leaf2 = makeLeaf("Income2", 2)

    let sut = makeOrTree("alts", [leaf1, leaf2])

    XCTAssertEqual(sut.name, "alts")
    XCTAssertEqual(sut.children?.count, 2)
  }

  func test_scenarios_for_stream() {
    let sut = makeLeaf("Income1", 1_000, MonthYear(.jan, 2024), MonthYear(.dec, 2024))

    let result = sut.scenarios(Scenarios([Scenario("A"), Scenario("B")]))
    let array = Array(result)

    XCTAssertEqual(array.count, 2)
    XCTAssertEqual(array[0].net(12, of: MonthYear(.dec, 2024)), Money(1_000))
    XCTAssertEqual(array[1].net(12, of: MonthYear(.dec, 2024)), Money(1_000))
    XCTAssertEqual(array[0].net(13, of: MonthYear(.jan, 2025)), Money(0))
    XCTAssertEqual(array[1].net(13, of: MonthYear(.jan, 2025)), Money(0))
  }

  func test_scenarios_for_and_tree() {
    let leaf1 = makeLeaf("Income1", 1_000, MonthYear(.jan, 2024), MonthYear(.dec, 2024))
    let leaf2 = makeLeaf("Income2", 2_000, MonthYear(.jun, 2024), MonthYear(.jun, 2025))

    let sut = makeAndTree("parent", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario(""), Scenario("")]))
    let array = Array(result)

    XCTAssertEqual(array.count, 2)
    XCTAssertEqual(array[0].net(1, of: MonthYear(.jan, 2024)), Money(1_000))
    XCTAssertEqual(array[1].net(1, of: MonthYear(.jan, 2024)), Money(1_000))
    XCTAssertEqual(array[0].net(6, of: MonthYear(.jun, 2024)), Money(3_000))
    XCTAssertEqual(array[1].net(6, of: MonthYear(.jun, 2024)), Money(3_000))
    XCTAssertEqual(array[0].net(13, of: MonthYear(.jan, 2025)), Money(2_000))
    XCTAssertEqual(array[1].net(13, of: MonthYear(.jan, 2025)), Money(2_000))
  }

  func test_scenarios_for_and_tree_with_or_child() {
    let leaf1a = makeLeaf("Income1a", 1_000)
    let leaf1b = makeLeaf("Income1b", 1_500)
    let leaf2 = makeLeaf("Income2", 2_000)
    let orTree = makeOrTree( "scenarios", [leaf1a, leaf1b])
    let sut = makeAndTree("parent", [orTree, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("")]))
    let resultSet = Set(result.map { $0.net(1, of: MonthYear(.jan, 2024)) })

    XCTAssertEqual(resultSet.count, 2)
    XCTAssertEqual(resultSet, [3_000, 3_500])
  }

  func test_scenarios_for_or_tree() {
    let leaf1 = makeLeaf("Income1", 1_000, MonthYear(.jan, 2024), MonthYear(.dec, 2024))
    let leaf2 = makeLeaf("Income2", 2_000, MonthYear(.jun, 2024), MonthYear(.jun, 2025))

    let sut = makeOrTree("parent", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("")]))
    let array = Array(result)

    XCTAssertEqual(array.count, 2)
    let (x, y) = array[0].net(1, of: MonthYear(.jan, 2024)) != 0 ? (array[0], array[1]) : (array[1], array[0])
    XCTAssertEqual(
      [x.net(1, of: MonthYear(.jan, 2024)), x.net(6, of: MonthYear(.jun, 2024)), x.net(13, of: MonthYear(.jan, 2025))],
      [Money(1_000), Money(1_000), Money(0)]
    )
    XCTAssertEqual(
      [y.net(1, of: MonthYear(.jan, 2024)), y.net(6, of: MonthYear(.jun, 2024)), y.net(13, of: MonthYear(.jan, 2025))],
      [Money(0), Money(2_000), Money(2_000)]
    )
  }

  func test_multiple_scenarios_for_or_tree() {
    let scenario1 = Scenario("")
    let scenario2 = Scenario("")
    scenario2.add(makeStream("annuity", 500))

    let leaf1 = makeLeaf("Income1", 1_000)
    let leaf2 = makeLeaf("Income2", 2_000)

    let sut = makeOrTree("parent", [leaf1, leaf2])

    let scenarios = sut.scenarios(Scenarios([scenario1, scenario2]))
    let result = Array(scenarios)
    let month = MonthYear(.jan, 2024)

    XCTAssertEqual(result.count, 4)
    XCTAssertTrue(result.contains { $0.net(1, of: month) == Money(1_000) })
    XCTAssertTrue(result.contains { $0.net(1, of: month) == Money(2_000) })
    XCTAssertTrue(result.contains { $0.net(1, of: month) == Money(1_500) })
    XCTAssertTrue(result.contains { $0.net(1, of: month) == Money(2_500) })
  }

  func test_scenarios_for_or_tree_get_names_from_starting_scenario() {
    let leaf1 = makeLeaf("Income1", 1_000)
    let leaf2 = makeLeaf("Income2", 2_000)

    let sut = makeOrTree("Job", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("")]))
    let array = Array(result)

    XCTAssertEqual(array.count, 2)
    let names = array.map { $0.name }
    XCTAssertEqual(Set(names), [" • Job (1) - Income1", " • Job (2) - Income2"])
  }

  func test_scenarios_for_nested_or_trees_gets_combined_name() {
    let leaf1 = makeLeaf("Income1", 1_000)
    let leaf2 = makeLeaf("Income2", 2_000)

    let or1 = makeOrTree("Job", [leaf1])
    let or2 = makeOrTree("Salary", [leaf2])
    let sut = makeAndTree("And", [or1, or2])

    let result = sut.scenarios(Scenarios([Scenario("Start")]))
    let array = Array(result)

    XCTAssertEqual(array.count, 1)
    XCTAssertEqual(array.first!.name, "Start • Job (1) - Income1 • Salary (1) - Income2")
  }
}