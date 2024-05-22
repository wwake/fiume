class Scenarios: Sequence {
  var scenarios = Set<Scenario>()

  init(_ scenarios: [Scenario] = []) {
    self.scenarios = Set(scenarios)
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
