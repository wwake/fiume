@testable import fiume
import fiume_model
import Testing

struct TheDateAssumptions {
  func makeAssumptions() -> DateAssumptions {
    DateAssumptions()
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
}
