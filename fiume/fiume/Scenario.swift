import Foundation

class Scenario: Identifiable {
  let id = UUID()
  var items = [String: Stream]()

  init() { }

  convenience init(_ other: Scenario) {
    self.init()
    let copy = other.items
    self.items = copy
  }

  func add(_ stream: Stream) {
    if items[stream.name] == nil {
      items[stream.name] = stream
    } else {
      let original = items[stream.name]!
      let revised = original.merge(stream)
      items[stream.name] = revised
    }
  }

  func net(_ month: MonthNumber) -> Money {
    items.values.reduce(Money(0)) { soFar, stream in
      soFar + stream.amount(month: month)
    }
  }

  func copy() -> Scenario {
      Scenario(self)
  }

  func project(_ months: ClosedRange<Int>) -> ScenarioNetWorth {
    var result = [MonthlyNetWorth]()
    var runningTotal = Money(0)
    months.forEach { month in
      runningTotal += net(month)
      result.append(MonthlyNetWorth(month: month, amount: runningTotal))
    }
    return ScenarioNetWorth(name: "Scenario \(UUID())", netWorthByMonth: result)
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
