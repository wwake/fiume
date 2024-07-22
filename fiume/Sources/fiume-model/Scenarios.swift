public class Scenarios: Sequence {
  private var scenarios = Set<Scenario>()

  public init(_ scenarios: [Scenario] = []) {
    self.scenarios = Set(scenarios)
  }

  public var count: Int {
    scenarios.count
  }

  public func add(pool: Leia) -> Scenarios {
    let result = Scenarios(Array(scenarios))
    scenarios.forEach {
      $0.add(pool: pool)
    }
    return result
  }

  public func add(stream: Leia) -> Scenarios {
    let result = Scenarios(Array(scenarios))
    scenarios.forEach {
      $0.add(stream: stream)
    }
    return result
  }

  public func add(_ other: Scenarios) {
    scenarios.formUnion(other.scenarios)
  }

  public func makeIterator() -> Set<Scenario>.Iterator {
    scenarios.makeIterator()
  }
}
