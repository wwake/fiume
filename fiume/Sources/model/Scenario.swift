import Foundation

class Scenario: Identifiable {
  let id = UUID()
  let name: String
  let people: People

  typealias NameToLeia = [String: Leia]
  var streams = NameToLeia()
  var pools = NameToLeia()

  init(_ name: String, people: People) {
    self.name = name
    self.people = people
  }

  private convenience init(_ other: Scenario, _ newName: String) {
    self.init(newName, people: other.people)
    let copy = other.streams
    self.streams = copy
  }

  func copy(_ newName: String) -> Scenario {
    Scenario(self, newName)
  }

  func add(pool: Leia) {
    add(pool, &pools)
  }

  func add(stream: Leia) {
    add(stream, &streams)
  }

  fileprivate func add(_ leia: Leia, _ map: inout NameToLeia) {
    if map[leia.name] == nil {
      map[leia.name] = leia
    } else {
      let original = map[leia.name]!
      let revised = original.update(overriddenBy: leia)
      map[leia.name] = revised
    }
  }

  func netWorth(_ range: ClosedRange<MonthYear>) -> ScenarioNetWorth {
    var result = [MonthlyNetWorth]()
    var netIncomeToDate = Money(0)
    range.forEach { monthYear in
      let netIncomeForMonth = netIncome(at: monthYear)
      netIncomeToDate += netIncomeForMonth

      let netAssetsAtMonth = netAssets(at: monthYear)
      let netWorthAtMonth = netIncomeToDate + netAssetsAtMonth

      result.append(MonthlyNetWorth(month: monthYear, amount: netWorthAtMonth))
    }
    return ScenarioNetWorth(name: name, netWorthByMonth: result)
  }

  func netIncome(at month: MonthYear) -> Money {
    streams.values.reduce(Money(0)) { net, stream in
      net + stream.amount(at: month, people: people)
    }
  }

  func netAssets(at month: MonthYear) -> Money {
    pools.values.reduce(Money(0)) { net, pool in
      net + pool.amount(at: month, people: people)
    }
  }
}

extension Scenario: Hashable {
	static func == (lhs: Scenario, rhs: Scenario) -> Bool {
    lhs.id == rhs.id
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
	}
}
