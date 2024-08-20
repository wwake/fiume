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
}
