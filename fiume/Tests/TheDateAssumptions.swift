@testable import fiume
import fiume_model
import Testing

struct TheDateAssumptions {
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
  func knows_current_date_when_found() {
    let sut = makeAssumptions()
    let assumption = Assumption(type: .date, name: "Holiday", min: 2020, max: 2030, current: 2025)
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
    sut.add(Assumption(type: .date, name: "Z", min: 0, max: 10, current: 5))
    sut.add(Assumption(type: .date, name: "A", min: 0, max: 10, current: 9))

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
    sut.add(Assumption(type: .date, name: "Z", min: 0, max: 10, current: 5))
    sut.add(Assumption(type: .date, name: "A", min: 0, max: 10, current: 9))

    #expect(sut.names == ["A", "Z"])
  }
}
