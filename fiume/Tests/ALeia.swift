@testable import fiume
import fiume_model
import Testing

struct ALeia {
  private let people = People()
  let ignoredScenario = Scenario("ignored", people: People())

  @Test
  func returns_zero_outside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct, .income)
    #expect(sut.signedAmount(at: 2019.dec, people: people, scenario: ignoredScenario) == Money(0))
  }

  @Test
  func returns_amount_inside_month_year_date_range() throws {
    let sut = makeLeia(100, first: 2020.jan, last: 2020.oct, .income)
    #expect(sut.signedAmount(at: 2020.jan, people: people, scenario: ignoredScenario) == Money(100))
  }

  @Test
  func adds_no_interest_for_start_month() {
    let sut = makeLeia(name: "income", 100, dates: DateRange.always, leiaType: .income)

    #expect(sut.signedAmount(start: 2200.jan, at: 2200.jan, people: people, scenario: ignoredScenario) == Money(100))
  }

  @Test
  func applies_growth() {
    Assumptions.shared.add(
      Assumption(type: .percent, name: "Inflation", min: 0, max: 100, current: 50)
    )
    // Yearly interest at 50% ~~ monthly interest at 34%
    var sut = makeLeia(name: "income", 1000, dates: DateRange.always, leiaType: .income)
    sut.growth = "Inflation"

    #expect(sut.signedAmount(
      start: 2200.jan,
      at: 2200.feb,
      people: People(),
      scenario: ignoredScenario
    ) == 1034)
  }

  @Test
  func starts_growing_only_when_it_becomes_active() {
    Assumptions.shared.add(
      Assumption(type: .percent, name: "Inflation", min: 0, max: 100, current: 50)
    )
    // Yearly interest at 50% ~~ monthly interest at 34%
    var sut = makeLeia(name: "income", 1000, dates: DateRange(.month(2021.jan), .unchanged), leiaType: .asset)
    sut.growth = "Inflation"

    #expect(sut.signedAmount(
      start: 2020.jan,
      at: 2021.jan,
      people: People(),
      scenario: ignoredScenario
    ) == 1000)

    #expect(sut.signedAmount(
      start: 2020.jan,
      at: 2022.jan,
      people: People(),
      scenario: ignoredScenario
    ) == 1500)
  }
}
