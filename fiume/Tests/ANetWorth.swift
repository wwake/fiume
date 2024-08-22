@testable import fiume
import fiume_model
import Testing

struct ANetWorth {
  let people = People()

  @Test
  func for_pool_considers_dates() {
    let leia = makeLeia(name: "asset", 1_000, dates: DateRange(.month(2024.jan), .month(2024.dec)), leiaType: .asset)
    let sut = Scenario("A")
    sut.add(leia)

    let result = sut.netWorth(2024.jan...2025.jan)

    #expect(result.netWorthByMonth.first!.netWorth == Money(1_000))
    #expect(result.netWorthByMonth.last!.netWorth == Money(0))
  }

  @Test
  func for_stream_considers_dates() {
    let leia = makeLeia(name: "stream", 1_000, dates: DateRange(.month(2024.jan), .month(2024.dec)), leiaType: .income)
    let sut = Scenario("A")
    sut.add(leia)

    let result = sut.netWorth(2024.jan...2025.jan)

    #expect(result.netWorthByMonth.first!.netWorth == Money(1_000))
    #expect(result.netWorthByMonth.last!.netWorth == Money(12_000))
  }

  @Test
  func computes_netIncome_for_distinct_streams() {
    let scenario = AScenario.makeScenario(
      makeLeia(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec, .income),
      makeLeia(name: "Income2", 500, first: DateSpecifier.month(2024.oct), last: DateSpecifier.unchanged)
    )

    let result = NetWorth(
      scenario: scenario,
      leias: [scenario.find("Income1")!, scenario.find("Income2")!],
      range: 2024.jan...2025.jan
    ).compute()

    #expect(result.netWorthByMonth[0].month == 2024.jan)
    #expect(result.netWorthByMonth[0].netWorth == 1_000)

    #expect(result.netWorthByMonth[9].month == 2024.oct)
    #expect(result.netWorthByMonth[9].netWorth == 9_000 + 1_500)

    #expect(result.netWorthByMonth[12].month == 2025.jan)
    #expect(result.netWorthByMonth[12].netWorth == 9_000 + 3 * 1_500 + 500)
  }
}
