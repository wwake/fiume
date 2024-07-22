public class Scenarios: Sequence {
  private var scenarios = Set<Scenario>()

  init(_ scenarios: [Scenario] = []) {
    self.scenarios = Set(scenarios)
  }

  var count: Int {
    scenarios.count
  }

  func add(pool: Leia) -> Scenarios {
    let result = Scenarios(Array(scenarios))
    scenarios.forEach {
      $0.add(pool: pool)
    }
    return result
  }

  func add(stream: Leia) -> Scenarios {
    let result = Scenarios(Array(scenarios))
    scenarios.forEach {
      $0.add(stream: stream)
    }
    return result
  }

  func add(_ other: Scenarios) {
    scenarios.formUnion(other.scenarios)
  }

  public func makeIterator() -> Set<Scenario>.Iterator {
    scenarios.makeIterator()
  }
}
