class ScenarioSet {
  var scenarios = Set<Scenario>()

  init(_ scenarios: [Scenario] = []) {
    self.scenarios = Set(scenarios)
  }
}
