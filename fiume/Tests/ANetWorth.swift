@testable import fiume
import fiume_model
import Testing

struct ANetWorth {
  let people = People()

  @Test
  func for_pool_considers_dates() {
    let leia = makeLeia(name: "stream", 1_000, dates: DateRange(.month(2024.jan), .month(2024.dec)), leiaType: .asset)
    let sut = Scenario("A", people: people)
    sut.add(leia)

    let result = sut.netWorth(2024.jan...2025.jan)

    #expect(result.netWorthByMonth.first!.amount == Money(1_000))
    #expect(result.netWorthByMonth.last!.amount == Money(0))
  }

  @Test
  func for_stream_considers_dates() {
    let leia = makeLeia(name: "stream", 1_000, dates: DateRange(.month(2024.jan), .month(2024.dec)), leiaType: .income)
    let sut = Scenario("A", people: people)
    sut.add(leia)

    let result = sut.netWorth(2024.jan...2025.jan)

    #expect(result.netWorthByMonth.first!.amount == Money(1_000))
    #expect(result.netWorthByMonth.last!.amount == Money(12_000))
  }
}
