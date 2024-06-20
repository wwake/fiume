@testable import fiume
import Testing

struct APlan {
  private func makeStream(_ name: String, _ amount: Int) -> fiume.Stream {
    Stream(name, Money(amount), first: .month(2024.jan), last: .unchanged)
  }

  private func makeLeaf(
    _ name: String,
    _ amount: Int,
    _ first: MonthYear = 2024.jan,
    _ last: MonthYear = 2034.dec
  ) -> Plan {
    let stream = Stream(name, Money(amount), first: .month(first), last: .month(last))
    return Plan.makeStream(stream)
  }

  private func makeAndTree(_ name: String, _ children: [Plan]) -> Plan {
    let result = Plan.makeAnd(name)
    children.forEach {
      result.append($0)
    }
    return result
  }

  private func makeOrTree(_ name: String, _ children: [Plan]) -> Plan {
    let result = Plan.makeOr(name)
    children.forEach {
      result.append($0)
    }
    return result
  }

  @Test
  func makes_a_leaf() throws {
    let sut = makeLeaf("Income", 100, 2024.mar, 2024.dec)

    #expect(sut.name == "Income")
    #expect(sut.children == nil)
    #expect(sut.parent == nil)
  }

  @Test
  func makes_a_composite() {
    let leaf1 = makeLeaf("Income1", 1)
    let leaf2 = makeLeaf("Income2", 2)
    let leaf3 = makeLeaf("Income3", 3)

    let parent = makeAndTree("parent", [leaf1, leaf2])
    let sut = makeAndTree("grandparent", [parent, leaf3])

    #expect(sut.name == "grandparent")
    #expect(sut.children?.count == 2)
    #expect(parent.children?.count == 2)

    #expect(leaf1.parent!.name == "parent")
    #expect(parent.parent!.name == "grandparent")
    #expect(sut.parent == nil)
  }

  @Test
  func scenarios_for_stream() {
    let sut = makeLeaf("Income1", 1_000, 2024.jan, 2024.dec)

    let result = sut.scenarios(Scenarios([Scenario("A"), Scenario("B")]))
    let array = Array(result)

    #expect(array.count == 2)
    #expect(array[0].net(at: 2024.dec) == Money(1_000))
    #expect(array[1].net(at: 2024.dec) == Money(1_000))
    #expect(array[0].net(at: 2025.jan) == Money(0))
    #expect(array[1].net(at: 2025.jan) == Money(0))
  }

  @Test
  func scenarios_for_and_tree() {
    let leaf1 = makeLeaf("Income1", 1_000, 2024.jan, 2024.dec)
    let leaf2 = makeLeaf("Income2", 2_000, 2024.jun, 2025.jun)

    let sut = makeAndTree("parent", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario(""), Scenario("")]))
    let array = Array(result)

    #expect(array.count == 2)
    #expect(array[0].net(at: 2024.jan) == Money(1_000))
    #expect(array[1].net(at: 2024.jan) == Money(1_000))
    #expect(array[0].net(at: 2024.jun) == Money(3_000))
    #expect(array[1].net(at: 2024.jun) == Money(3_000))
    #expect(array[0].net(at: 2025.jan) == Money(2_000))
    #expect(array[1].net(at: 2025.jan) == Money(2_000))
  }

  @Test
  func scenarios_for_and_tree_with_or_child() {
    let leaf1a = makeLeaf("Income1a", 1_000)
    let leaf1b = makeLeaf("Income1b", 1_500)
    let leaf2 = makeLeaf("Income2", 2_000)
    let orTree = makeOrTree( "scenarios", [leaf1a, leaf1b])
    let sut = makeAndTree("parent", [orTree, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("")]))
    let resultSet = Set(result.map { $0.net(at: 2024.jan) })

    #expect(resultSet.count == 2)
    #expect(resultSet == [3_000, 3_500])
  }

  @Test
  func scenarios_for_or_tree() {
    let leaf1 = makeLeaf("Income1", 1_000, 2024.jan, 2024.dec)
    let leaf2 = makeLeaf("Income2", 2_000, 2024.jun, 2025.jun)

    let sut = makeOrTree("parent", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("")]))
    let array = Array(result)

    #expect(array.count == 2)
    let (x, y) = array[0].net(at: 2024.jan) != 0 ? (array[0], array[1]) : (array[1], array[0])
    let nets1 = [x.net(at: 2024.jan), x.net(at: 2024.jun), x.net(at: 2025.jan)]
    #expect(nets1 == [Money(1_000), Money(1_000), Money(0)])

    let nets2: [Money] = [y.net(at: 2024.jan), y.net(at: 2024.jun), y.net(at: 2025.jan)]
    #expect(nets2 == [Money(0), Money(2_000), Money(2_000)])
  }

  @Test
  func multiple_scenarios_for_or_tree() {
    let scenario1 = Scenario("")
    let scenario2 = Scenario("")
    scenario2.add(makeStream("annuity", 500))

    let leaf1 = makeLeaf("Income1", 1_000)
    let leaf2 = makeLeaf("Income2", 2_000)

    let sut = makeOrTree("parent", [leaf1, leaf2])

    let scenarios = sut.scenarios(Scenarios([scenario1, scenario2]))
    let result = Array(scenarios)
    let month = 2024.jan

    #expect(result.count == 4)
    #expect(result.contains { $0.net(at: month) == Money(1_000) })
    #expect(result.contains { $0.net(at: month) == Money(2_000) })
    #expect(result.contains { $0.net(at: month) == Money(1_500) })
    #expect(result.contains { $0.net(at: month) == Money(2_500) })
  }

  @Test
  func scenarios_for_or_tree_get_names_from_starting_scenario() {
    let leaf1 = makeLeaf("Income1", 1_000)
    let leaf2 = makeLeaf("Income2", 2_000)

    let sut = makeOrTree("Job", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("")]))
    let array = Array(result)

    #expect(array.count == 2)
    let names = array.map { $0.name }
    #expect(Set(names) == [" • Job (1) - Income1", " • Job (2) - Income2"])
  }

  @Test
  func scenarios_for_nested_or_trees_gets_combined_name() {
    let leaf1 = makeLeaf("Income1", 1_000)
    let leaf2 = makeLeaf("Income2", 2_000)

    let or1 = makeOrTree("Job", [leaf1])
    let or2 = makeOrTree("Salary", [leaf2])
    let sut = makeAndTree("And", [or1, or2])

    let result = sut.scenarios(Scenarios([Scenario("Start")]))
    let array = Array(result)

    #expect(array.count == 1)
    #expect(array.first!.name == "Start • Job (1) - Income1 • Salary (1) - Income2")
  }
}
