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

  func project(of range: ClosedRange<MonthYear> = MonthYear(month: 0, year: 2000)...MonthYear(month: 0, year: 2000), _ months: ClosedRange<MonthNumber>) -> ScenarioNetWorth {
    var result = [MonthlyNetWorth]()
    var runningTotal = Money(0)
    months.forEach { month in
      runningTotal += net(of: range.lowerBound, month)
      result.append(MonthlyNetWorth(month: month, amount: runningTotal))
    }
    return ScenarioNetWorth(name: name, netWorthByMonth: result)
  }

  func net(of cursor: MonthYear = MonthYear(month: 1, year: 1), _ month: MonthNumber) -> Money {
    items.values.reduce(Money(0)) { soFar, stream in
      soFar + stream.amount(of: cursor, month: month)
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
