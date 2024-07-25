@testable import fiume
import fiume_model
import Testing

struct AnAmount {
  @Test
  func knows_simple_amount() {
    let sut = Amount(100)
    #expect(sut.value() == 100)
    #expect(sut.description == "$100/mo")
  }

  @Test
  func knows_relative_amount() {
    let scenario = Scenario("the scenario", people: People())
    let stream = Leia(name: "source stream", amount: Amount(100), dates: DateRange.null)
    scenario.add(stream: stream)

    let sut = Amount(0.67, "source stream")

    #expect(sut.value(at: 2025.jan, scenario) == Money(67))
    #expect(sut.description == "0.67 of source stream")
  }
}
