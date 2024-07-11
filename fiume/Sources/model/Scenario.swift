import Foundation

class Scenario: Identifiable {
  let id = UUID()
  let name: String
  let people: People

  var streams = [String: Stream]()
  var pools = [String: Pool]()

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

  func add(_ pool: Pool) {
    if pools[pool.name] == nil {
      pools[pool.name] = pool
    } else {
      let original = pools[pool.name]!
      let revised = original.update(overriddenBy: pool)
      pools[pool.name] = revised
    }
  }

  func add(_ stream: Stream) {
    if streams[stream.name] == nil {
      streams[stream.name] = stream
    } else {
      let original = streams[stream.name]!
      let revised = original.update(overriddenBy: stream)
      streams[stream.name] = revised
    }
  }

  func netWorth(_ range: ClosedRange<MonthYear>) -> ScenarioNetWorth {
    var result = [MonthlyNetWorth]()
    var runningTotal = Money(0)
    range.forEach { monthYear in
      runningTotal += netIncome(at: monthYear)
      result.append(MonthlyNetWorth(month: monthYear, amount: runningTotal))
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
