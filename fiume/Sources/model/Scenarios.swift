class Scenarios: Sequence {
  private var scenarios = Set<Scenario>()

  init(_ scenarios: [Scenario] = []) {
    self.scenarios = Set(scenarios)
  }

  var count: Int {
    scenarios.count
  }

  func add(_ stream: Stream) -> Scenarios {
    let result = Scenarios(Array(scenarios))
    scenarios.forEach {
      $0.add(stream)
    }
    return result
  }

  func add(_ other: Scenarios) {
    scenarios.formUnion(other.scenarios)
  }

  func makeIterator() -> Set<Scenario>.Iterator {
    scenarios.makeIterator()
  }
}
