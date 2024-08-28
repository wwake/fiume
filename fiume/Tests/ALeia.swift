@testable import fiume
import fiume_model
import Testing

struct ALeia {
  private let people = People()
  let ignoredScenario = Scenario("ignored")

  @Test
  func returns_zero_outside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct, .income)
    #expect(sut.signedAmount(at: 2019.dec, scenario: ignoredScenario) == Money(0))
  }

  @Test
  func returns_amount_inside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct, .income)
    #expect(sut.signedAmount(at: 2020.jan, scenario: ignoredScenario) == Money(100))
  }

  @Test
  func adds_no_interest_for_start_month() {
    let sut = makeLeia(name: "income", 100, dates: DateRange.always, leiaType: .income)

    #expect(sut.signedAmount(start: 2200.jan, at: 2200.jan, scenario: ignoredScenario) == Money(100))
  }

  @Test
  func applies_growth() {
    PercentAssumptions.shared.add(
      PercentAssumption(type: .percent, name: "Inflation", min: 0, max: 100, current: 50)
    )
    // Yearly interest at 50% ~~ monthly interest at 34%
    var sut = makeLeia(name: "income", 1000, dates: DateRange.always, leiaType: .income)
    sut.growth = "Inflation"

    #expect(sut.signedAmount(
      start: 2200.jan,
      at: 2200.feb,
      scenario: ignoredScenario
    ) == 1034)
  }

  @Test
  func starts_growing_only_when_it_becomes_active() {
    PercentAssumptions.shared.add(
      PercentAssumption(type: .percent, name: "Inflation", min: 0, max: 100, current: 50)
    )
    // Yearly interest at 50% ~~ monthly interest at 34%
    var sut = makeLeia(name: "income", 1000, dates: DateRange(.month(2021.jan), .unchanged), leiaType: .asset)
    sut.growth = "Inflation"

    #expect(sut.signedAmount(
      start: 2020.jan,
      at: 2021.jan,
      scenario: ignoredScenario
    ) == 1000)

    #expect(sut.signedAmount(
      start: 2020.jan,
      at: 2022.jan,
      scenario: ignoredScenario
    ) == 1500)
  }
}
