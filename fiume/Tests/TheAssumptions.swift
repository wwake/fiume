@testable import fiume
import fiume_model
import Testing

struct TheAssumptions {
  @Test
  func adds_an_assumption() {
    let assumptions = Assumptions()
    assumptions.add(Assumption(type: .percent, name: "the one", min: 1, max: 10, current: 5))
    #expect(assumptions.find("the one")!.name == "the one")
  }

  @Test
  func replaces_an_assumption() {
    let assumptions = Assumptions()
    let assumption = Assumption(type: .percent, name: "the one", min: 1, max: 10, current: 5)
    assumptions.add(assumption)
    assumptions.replace(Assumption(assumption, 7))
    #expect(assumptions.find("the one")!.current == 7)
  }

  @Test
  func verified_of_valid_name_yields_name() {
    let assumptions = Assumptions()
    assumptions.add(Assumption(type: .percent, name: "present", min: 0, max: 0, current: 0))

    #expect(assumptions.verified("present") == "present")
  }

  @Test
  func verified_of_missing_name_yields_flatGrowth() {
    let assumptions = Assumptions()
    #expect(assumptions.verified("missing") == Assumption.flatGrowth)
  }
}
