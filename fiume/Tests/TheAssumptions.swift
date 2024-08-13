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
}
