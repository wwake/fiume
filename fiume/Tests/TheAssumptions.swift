@testable import fiume
import fiume_model
import Testing

struct TheAssumptions {
  func makeAssumptions() -> Assumptions {
    Assumptions()
  }

  func makeEmptyAssumptions() -> Assumptions {
    let assumptions = makeAssumptions()
    Array(assumptions).forEach {
      assumptions.remove($0.name)
    }
    return assumptions
  }

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

  @Test
  func knows_current_date_when_found() {
    let sut = makeAssumptions()
    let assumption = Assumption(type: .date, name: "Holiday", min: 2020, max: 2030, current: 2025)
    sut.add(assumption)

    #expect(sut.asMonthYear("Holiday") == 2025.jan)
  }

  @Test
  func defaults_current_date_when_not_found() {
    let sut = makeAssumptions()

    #expect(sut.asMonthYear("Missing") == 1900.jan)
  }

  @Test
  func names_returns_alphabetical_list_for_type() {
    let sut = makeEmptyAssumptions()
    sut.add(Assumption(type: .percent, name: "P", min: 0, max: 10, current: 7))
    sut.add(Assumption(type: .date, name: "Z", min: 0, max: 10, current: 5))
    sut.add(Assumption(type: .date, name: "A", min: 0, max: 10, current: 9))

    #expect(sut.names(.date) == ["A", "Z"])
    #expect(sut.count(.date) == 2)
  }

  @Test
  func knows_its_sections() {
    let sut = makeEmptyAssumptions()

    let result = sut
      .sections
      .map { $0.name }

    #expect(result == ["Annual Percentage Rate", "Date"])
  }
}
