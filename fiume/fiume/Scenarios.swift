class Scenarios {
  var scenarios = Set<Scenario>()

  init(_ scenarios: [Scenario] = []) {
    self.scenarios = Set(scenarios)
  }

  func add(_ stream: Stream) -> Scenarios {
    scenarios.forEach {
      $0.add(stream)
    }
    return self
  }
}
