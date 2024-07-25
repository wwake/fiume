@testable import fiume
import fiume_model
import Testing

struct AnAmount {
  @Test
  func knows_simple_amount() {
    let sut = Amount(100)
    #expect(sut.value() == 100)
  }

  //@Test
  func know_relative_amount() {
    let scenario = Scenario("the scenario", people: People())
    let stream = Leia(name: "source stream", amount: Amount(100), dates: DateRange.null)
    scenario.add(stream: stream)

    let sut = Amount(0.5, "source stream")

    #expect(sut.value(scenario) == Money(50))
  }
}
