@testable import fiume
import fiume_model
import Testing

struct TheAssumptions {
  @Test
  func adds_an_assumption() {
    let sut = Assumptions()
    sut.wasChanged = false

    sut.add(Assumption(type: .percent, name: "the one", min: 1, max: 10, current: 5))

    #expect(sut.wasChanged)
    #expect(sut.find("the one")!.name == "the one")
  }

  @Test
  func remove_removes_assumption() {
    let sut = Assumptions()
    sut.add(Assumption(type: .percent, name: "the one", min: 1, max: 10, current: 5))
    sut.wasChanged = false

    sut.remove("the one")

    #expect(sut.wasChanged)
    #expect(sut.find("the one") == nil)
  }

  @Test
  func replaces_an_assumption() {
    let sut = Assumptions()
    let assumption = Assumption(type: .percent, name: "the one", min: 1, max: 10, current: 5)
    sut.add(assumption)
    sut.wasChanged = false

    sut.replace(Assumption(assumption, 7))

    #expect(sut.wasChanged)
    #expect(sut.find("the one")!.current == 7)
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

  @Test
  func load_replaces_assumptions() {
    let assumptions = Assumptions()
    let assumption = Assumption(type: .percent, name: "the one", min: 1, max: 10, current: 5)
    assumptions.add(assumption)

    let sut = Assumptions()
    sut.wasChanged = true
    sut.load(assumptions)

    #expect(!sut.wasChanged)
    #expect(sut.find("the one") != nil)
  }

  @Test
  func returns_0_percent_if_name_is_null() {
    let assumptions = Assumptions()
    #expect(assumptions.findMonthlyRate(nil) == 0.0)
  }

  @Test
  func returns_0_percent_for_unknown_name() {
    let assumptions = Assumptions()
    #expect(assumptions.findMonthlyRate("unknown") == 0.0)
  }

  @Test
  func returns_percent_for_known_name() {
    let assumptions = Assumptions()
    assumptions.add(Assumption(type: .percent, name: "ROI", min: 1, max: 100, current: 100))

    #expect(assumptions.findMonthlyRate("ROI") >= 1.059463094)
    #expect(assumptions.findMonthlyRate("ROI") <= 1.059463095)
  }
}
