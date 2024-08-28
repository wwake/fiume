@testable import fiume
import fiume_model
import Testing

struct ThePercentAssumptions {
  @Test
  func adds_an_assumption() {
    let sut = PercentAssumptions()
    sut.wasChanged = false

    sut.add(PercentAssumption(type: .percent, name: "the one", min: 1, max: 10, current: 5))

    #expect(sut.wasChanged)
    #expect(sut.find("the one")!.name == "the one")
  }

  @Test
  func remove_removes_assumption() {
    let sut = PercentAssumptions()
    sut.add(PercentAssumption(type: .percent, name: "the one", min: 1, max: 10, current: 5))
    sut.wasChanged = false

    sut.remove("the one")

    #expect(sut.wasChanged)
    #expect(sut.find("the one") == nil)
  }

  @Test
  func replaces_an_assumption() {
    let sut = PercentAssumptions()
    let assumption = PercentAssumption(type: .percent, name: "the one", min: 1, max: 10, current: 5)
    sut.add(assumption)
    sut.wasChanged = false

    sut.replace(PercentAssumption(assumption, 7))

    #expect(sut.wasChanged)
    #expect(sut.find("the one")!.current == 7)
  }

  @Test
  func verified_of_valid_name_yields_name() {
    let assumptions = PercentAssumptions()
    assumptions.add(PercentAssumption(type: .percent, name: "present", min: 0, max: 0, current: 0))

    #expect(assumptions.verified("present") == "present")
  }

  @Test
  func verified_of_missing_name_yields_flatGrowth() {
    let assumptions = PercentAssumptions()
    #expect(assumptions.verified("missing") == PercentAssumption.flatGrowth)
  }

  @Test
  func load_replaces_assumptions() {
    let assumptions = PercentAssumptions()
    let assumption = PercentAssumption(type: .percent, name: "the one", min: 1, max: 10, current: 5)
    assumptions.add(assumption)

    let sut = PercentAssumptions()
    sut.wasChanged = true
    sut.load(assumptions)

    #expect(!sut.wasChanged)
    #expect(sut.find("the one") != nil)
  }

  @Test
  func returns_0_percent_if_name_is_null() {
    let assumptions = PercentAssumptions()
    #expect(assumptions.findMonthlyRate(nil) == 0.0)
  }

  @Test
  func returns_0_percent_for_unknown_name() {
    let assumptions = PercentAssumptions()
    #expect(assumptions.findMonthlyRate("unknown") == 0.0)
  }

  @Test
  func returns_percent_for_known_name() {
    let assumptions = PercentAssumptions()
    assumptions.add(PercentAssumption(type: .percent, name: "ROI", min: 1, max: 100, current: 100))

    #expect(assumptions.findMonthlyRate("ROI") >= 1.059463094)
    #expect(assumptions.findMonthlyRate("ROI") <= 1.059463095)
  }
}
