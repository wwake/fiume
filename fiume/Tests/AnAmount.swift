@testable import fiume
import fiume_model
import Testing

struct AnAmount {
  let ignoredScenario = Scenario("ignored")

  @Test
  func knows_simple_amount_for_positive() {
    let sut = Amount(100)
    #expect(sut.value(monthlyInterest: 0.0, at: 2024.apr, ignoredScenario) == 100)
    #expect(sut.isNonNegative)
    #expect(sut.description == "$100")
  }

  @Test
  func knows_simple_amount_for_negative() {
    let sut = Amount(-100)
    #expect(sut.value(monthlyInterest: 0.0, at: 2024.jun, ignoredScenario) == -100)
    #expect(!sut.isNonNegative)
    #expect(sut.description == "$-100")
  }

  @Test
  func always_is_nonnegative_if_relative() {
    let sut = Amount(0.67, "source stream")
    #expect(sut.isNonNegative)
  }

  @Test
  func knows_relative_amount() {
    let scenario = Scenario("the scenario")
    let stream = Leia(
      name: "source stream",
      amount: Amount(100),
      dates: DateRange.always,
      type: .income,
      growth: PercentAssumption.flatGrowth
    )
    scenario.add(stream)

    let sut = Amount(0.67, "source stream")

    #expect(sut.value(monthlyInterest: 0.0, at: 2025.jan, scenario) == Money(67))
    #expect(sut.description == "67% of source stream")
  }

  @Test
  func adds_interest_based_on_number_of_months() {
    let sut = Amount(1000)
    #expect(sut.value(monthlyInterest: 1.25, start: 2024.jan, at: 2024.apr, ignoredScenario) == 1953)
  }
}
