@testable import fiume
import fiume_model
import Testing

struct TheAssumptions {
  @Test
  func addsAnAssumption() {
    let assumptions = Assumptions()
    assumptions.add(Assumption(type: .percent, name: "the one", min: 1, max: 10, current: 5))
    #expect(assumptions.find("the one")!.name == "the one")
  }

  @Test
  func replacesAnAssumption() {
    let assumptions = Assumptions()
    let assumption = Assumption(type: .percent, name: "the one", min: 1, max: 10, current: 5)
    assumptions.add(assumption)
    assumptions.replace(Assumption(assumption, 7))
    #expect(assumptions.find("the one")!.current == 7)
  }
}
