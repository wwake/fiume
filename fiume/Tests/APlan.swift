@testable import fiume
import fiume_model
import Testing

struct APlan {
  let people = People()

  private func makePool(
    _ name: String,
    _ amount: Int,
    _ first: MonthYear = 2024.jan,
    _ last: MonthYear = 2034.dec
  ) -> Plan {
    let pool = Leia(name: name, amount: .money(amount), dates: DateRange(.month(first), .month(last)), leiaType: .asset)
    return Plan.make(pool: pool)
  }

  private func makeLeia(_ name: String, _ amount: Int) -> Leia {
    Leia(name: name, amount: .money(amount), dates: DateRange(.month(2024.jan), .unchanged), leiaType: .income)
  }

  private func makeStream(
    _ name: String,
    _ amount: Int,
    _ first: MonthYear = 2024.jan,
    _ last: MonthYear = 2034.dec
  ) -> Plan {
    let stream = Leia(
      name: name,
      amount: .money(amount),
      dates: DateRange(.month(first), .month(last)),
      leiaType: .income
    )
    return Plan.make(stream: stream)
  }

  private func makeGroup(_ name: String, _ children: [Plan]) -> Plan {
    let result = Plan.makeGroup(name)
    children.forEach {
      result.append($0)
    }
    return result
  }

  private func makeScenarios(_ name: String, _ children: [Plan]) -> Plan {
    let result = Plan.makeScenarios(name)
    children.forEach {
      result.append($0)
    }
    return result
  }

  @Test
  func makes_a_pool() {
    let sut = makePool("Savings", 100, 2024.mar, 2024.dec)

    #expect(sut.name == "Savings")
    #expect(sut.children == nil)
  }

  @Test
  func makes_a_stream() throws {
    let sut = makeStream("Income", 100, 2024.mar, 2024.dec)

    #expect(sut.name == "Income")
    #expect(sut.children == nil)
  }

  @Test
  func makes_a_composite() {
    let leaf1 = makeStream("Income1", 1, 2020.jan, 2030.jan)
    let leaf2 = makeStream("Income2", 2, 2020.jan, 2030.jan)
    let leaf3 = makeStream("Income3", 3, 2020.jan, 2030.jan)

    let parent = makeGroup("parent", [leaf1, leaf2])
    let sut = makeGroup("grandparent", [parent, leaf3])

    #expect(sut.name == "grandparent")
    #expect(sut.children?.count == 2)
    #expect(parent.children?.count == 2)
  }

  @Test
  func removes_a_descendant() {
    let leaf1 = makeStream("Income1", 1, 2020.jan, 2030.jan)
    let parent = makeGroup("parent", [leaf1])
    let sut = makeGroup("grandparent", [parent])

    sut.remove(leaf1)

    #expect(sut.name == "grandparent")
    #expect(sut.children!.count == 1)
    #expect(sut.children![0].name == "parent")
    #expect(sut.children![0].children!.count == 0)
  }

  @Test
  func renames_a_group() {
    let plan = makeGroup("parent", [])
    plan.rename("new name")
    #expect(plan.name == "new name")
  }

  @Test
  func replaces_a_pool() {
    let plan = makePool("pool1", 750)
    let replacement = makePool("pool2", 500).leia!

    plan.replace(leia: replacement)

    #expect(plan.leia!.name == "pool2")
  }

  @Test
  func can_replace_its_stream() {
    let stream = makeLeia("test", 500)
    let plan = Plan.make(stream: makeLeia("original", 20))

    plan.replace(leia: stream)

    #expect(plan.leia!.name == "test")
    #expect(plan.leia!.amount.value(People()) == 500)
  }

  @Test
  func scenarios_for_pool() {
    let sut = makePool("Savings", 1_000_000, 2024.jan, 2024.dec)
    let result = sut.scenarios(Scenarios([Scenario("A", people: people), Scenario("B", people: people)]))
    let array = Array(result)

    #expect(array.count == 2)
    #expect(array[0].netAssets(at: 2024.dec) == Money(1_000_000))
    #expect(array[1].netAssets(at: 2024.dec) == Money(1_000_000))
    #expect(array[0].netAssets(at: 2025.jan) == Money(0))
    #expect(array[1].netAssets(at: 2025.jan) == Money(0))
  }

  @Test
  func scenarios_for_stream() {
    let sut = makeStream("Income1", 1_000, 2024.jan, 2024.dec)

    let result = sut.scenarios(Scenarios([Scenario("A", people: people), Scenario("B", people: people)]))
    let array = Array(result)

    #expect(array.count == 2)
    #expect(array[0].netIncome(at: 2024.dec) == Money(1_000))
    #expect(array[1].netIncome(at: 2024.dec) == Money(1_000))
    #expect(array[0].netIncome(at: 2025.jan) == Money(0))
    #expect(array[1].netIncome(at: 2025.jan) == Money(0))
  }

  @Test
  func scenarios_for_and_tree() {
    let leaf1 = makeStream("Income1", 1_000, 2024.jan, 2024.dec)
    let leaf2 = makeStream("Income2", 2_000, 2024.jun, 2025.jun)

    let sut = makeGroup("parent", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("", people: people), Scenario("", people: people)]))
    let array = Array(result)

    #expect(array.count == 2)
    #expect(array[0].netIncome(at: 2024.jan) == Money(1_000))
    #expect(array[1].netIncome(at: 2024.jan) == Money(1_000))
    #expect(array[0].netIncome(at: 2024.jun) == Money(3_000))
    #expect(array[1].netIncome(at: 2024.jun) == Money(3_000))
    #expect(array[0].netIncome(at: 2025.jan) == Money(2_000))
    #expect(array[1].netIncome(at: 2025.jan) == Money(2_000))
  }

  @Test
  func scenarios_for_and_tree_with_or_child() {
    let leaf1a = makeStream("Income1a", 1_000, 2020.jan, 2030.jan)
   let leaf1b = makeStream("Income1b", 1_500, 2020.jan, 2030.jan)
    let leaf2 = makeStream("Income2", 2_000, 2020.jan, 2030.jan)
    let orTree = makeScenarios( "scenarios", [leaf1a, leaf1b])
    let sut = makeGroup("parent", [orTree, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("", people: people)]))
    let resultSet = Set(result.map { $0.netIncome(at: 2024.jan) })

    #expect(resultSet.count == 2)
    #expect(resultSet == [3_000, 3_500])
  }

  @Test
  func scenarios_for_or_tree() {
    let leaf1 = makeStream("Income1", 1_000, 2024.jan, 2024.dec)
    let leaf2 = makeStream("Income2", 2_000, 2024.jun, 2025.jun)

    let sut = makeScenarios("parent", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("", people: people)]))
    let array = Array(result)

    #expect(array.count == 2)
    let (x, y) = array[0].netIncome(at: 2024.jan) != 0 ? (array[0], array[1]) : (array[1], array[0])
    let nets1 = [x.netIncome(at: 2024.jan), x.netIncome(at: 2024.jun), x.netIncome(at: 2025.jan)]
    #expect(nets1 == [Money(1_000), Money(1_000), Money(0)])

    let nets2: [Money] = [y.netIncome(at: 2024.jan), y.netIncome(at: 2024.jun), y.netIncome(at: 2025.jan)]
    #expect(nets2 == [Money(0), Money(2_000), Money(2_000)])
  }

  @Test
  func multiple_scenarios_for_or_tree() {
    let scenario1 = Scenario("", people: people)
    let scenario2 = Scenario("", people: people)
    scenario2.add(stream: makeLeia("annuity", 500))

    let leaf1 = makeStream("Income1", 1_000, 2020.jan, 2030.jan)
    let leaf2 = makeStream("Income2", 2_000, 2020.jan, 2030.jan)

    let sut = makeScenarios("parent", [leaf1, leaf2])

    let scenarios = sut.scenarios(Scenarios([scenario1, scenario2]))
    let result = Array(scenarios)
    let month = 2024.jan

    #expect(result.count == 4)
    #expect(result.contains { $0.netIncome(at: month) == Money(1_000) })
    #expect(result.contains { $0.netIncome(at: month) == Money(2_000) })
    #expect(result.contains { $0.netIncome(at: month) == Money(1_500) })
    #expect(result.contains { $0.netIncome(at: month) == Money(2_500) })
  }

  @Test
  func scenarios_for_or_tree_get_names_from_starting_scenario() {
    let leaf1 = makeStream("Income1", 1_000, 2020.jan, 2030.jan)
    let leaf2 = makeStream("Income2", 2_000, 2020.jan, 2030.jan)

    let sut = makeScenarios("Job", [leaf1, leaf2])

    let result = sut.scenarios(Scenarios([Scenario("", people: people)]))
    let array = Array(result)

    #expect(array.count == 2)
    let names = array.map { $0.name }
    #expect(Set(names) == [" • Job (1) - Income1", " • Job (2) - Income2"])
  }

  @Test
  func scenarios_for_nested_or_trees_gets_combined_name() {
    let leaf1 = makeStream("Income1", 1_000, 2020.jan, 2030.jan)
    let leaf2 = makeStream("Income2", 2_000, 2020.jan, 2030.jan)

    let or1 = makeScenarios("Job", [leaf1])
    let or2 = makeScenarios("Salary", [leaf2])
    let sut = makeGroup("And", [or1, or2])

    let result = sut.scenarios(Scenarios([Scenario("Start", people: people)]))
    let array = Array(result)

    #expect(array.count == 1)
    #expect(array.first!.name == "Start • Job (1) - Income1 • Salary (1) - Income2")
  }
}
