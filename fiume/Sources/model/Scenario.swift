import Foundation

class Scenario: Identifiable {
  let id = UUID()
  let name: String
  var items = [String: Stream]()

  init(_ name: String) {
    self.name = name
  }

  private convenience init(_ other: Scenario, _ newName: String) {
    self.init(newName)
    let copy = other.items
    self.items = copy
  }

  func copy(_ newName: String) -> Scenario {
    Scenario(self, newName)
  }

  func add(_ stream: Stream) {
    if items[stream.name] == nil {
      items[stream.name] = stream
    } else {
      let original = items[stream.name]!
      let revised = original.update(overriddenBy: stream)
      items[stream.name] = revised
    }
  }

  func project(of range: ClosedRange<MonthYear>) -> ScenarioNetWorth {
    var result = [MonthlyNetWorth]()
    var runningTotal = Money(0)
    range.forEach { monthYear in
      let month = range.lowerBound.distance(to: monthYear) + 1
      runningTotal += net(month, of: monthYear)
      result.append(MonthlyNetWorth(month: monthYear, amount: runningTotal))
    }
    return ScenarioNetWorth(name: name, netWorthByMonth: result)
  }

  func net(_ month: MonthNumber, of cursor: MonthYear) -> Money {
    items.values.reduce(Money(0)) { soFar, stream in
      soFar + stream.amount(at: cursor)
    }
  }
}

extension Scenario: Hashable {
	static func == (lhs: Scenario, rhs: Scenario) -> Bool {
		false
	}

	func hash(into hasher: inout Hasher) {
			hasher.combine(id)
	}
}
