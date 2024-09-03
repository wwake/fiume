@testable import fiume
import fiume_model
import Testing

struct TheDateAssumptions {
  func makeAssumptions() -> DateAssumptions {
    DateAssumptions()
  }

  func makeEmptyAssumptions() -> DateAssumptions {
    let assumptions = makeAssumptions()
    Array(assumptions).forEach {
      assumptions.remove($0.name)
    }
    return assumptions
  }

  @Test
  func adds_new_assumptions() {
    let sut = makeAssumptions()
    sut.wasChanged = false

    sut.add(DateAssumption("Holiday", min: 2020, max: 2030, current: 2025))

    #expect(sut.wasChanged)
    #expect(sut.find("Holiday") != nil)
  }

  @Test
  func remove_assumption() {
    let sut = makeAssumptions()
    sut.add(DateAssumption("Holiday", min: 2020, max: 2030, current: 2025))
    sut.wasChanged = false

    sut.remove("Holiday")

    #expect(sut.wasChanged)
    #expect(sut.find("the one") == nil)
  }

  @Test
  func replaces_an_assumption() {
    let sut = makeAssumptions()
    let assumption = DateAssumption("Holiday", min: 2020, max: 2030, current: 2025)
    sut.add(assumption)
    sut.wasChanged = false

    sut.replace(DateAssumption(assumption, 2027))

    #expect(sut.wasChanged)
    #expect(sut.find("Holiday")!.current == 2027)
  }

  @Test
  func knows_current_date_when_found() {
    let sut = makeAssumptions()
    let assumption = DateAssumption("Holiday", min: 2020, max: 2030, current: 2025)
    sut.add(assumption)

    #expect(sut.current("Holiday") == 2025.jan)
  }

  @Test
  func defaults_current_date_when_not_found() {
    let sut = makeAssumptions()

    #expect(sut.current("Missing") == 1900.jan)
  }

  @Test
  func first_returns_name_alphabetically_if_non_empty() {
    let sut = makeEmptyAssumptions()
    sut.add(DateAssumption("Z", min: 0, max: 10, current: 5))
    sut.add(DateAssumption("A", min: 0, max: 10, current: 9))

    #expect(sut.firstName == "A")
  }

  @Test
  func first_returns_nil_if_empty() {
    let sut = makeEmptyAssumptions()

    #expect(sut.firstName == nil)
  }

  @Test
  func names_returns_alphabetical_list() {
    let sut = makeEmptyAssumptions()
    sut.add(DateAssumption("Z", min: 0, max: 10, current: 5))
    sut.add(DateAssumption("A", min: 0, max: 10, current: 9))

    #expect(sut.names == ["A", "Z"])
  }
}