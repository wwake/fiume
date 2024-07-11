@testable import fiume
import Testing

extension fiume.Leia: Equatable {
  public static func == (lhs: fiume.Leia, rhs: fiume.Leia) -> Bool {
    lhs.name == rhs.name && lhs.amount == rhs.amount && lhs.first == rhs.first && lhs.last == rhs.last
  }
}

struct AScenario {
  private let people = People()

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: MonthYear,
    last: MonthYear
  ) -> fiume.Leia {
    Leia(name, Money(amount), first: DateSpecifier.month(first), last: DateSpecifier.month(last))
  }

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: DateSpecifier,
    last: DateSpecifier
  ) -> fiume.Leia {
    Leia(name, Money(amount), first: first, last: last)
  }

  private func makeScenario(_ streams: fiume.Leia...) -> Scenario {
    let result = Scenario("Scenario Name", people: people)
    streams.forEach {
      result.add($0)
    }
    return result
  }

  @Test
  func makes_independent_copies() {
    let sut = makeScenario(
      makeLeia(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec)
    )

    let result = sut.copy("altered name")
    let stream2 = makeLeia(name: "Income2", 2_000, first: 2024.jan, last: 2024.dec)
    result.add(stream2)

    #expect(sut.netIncome(at: 2024.jan) == Money(1_000))
    #expect(result.netIncome(at: 2024.jan) == Money(3_000))
    #expect(result.name == "altered name")
  }

  @Test
  func built_for_one_stream() {
    let sut = makeScenario(
      makeLeia(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec)
    )

    #expect(sut.netIncome(at: 2024.dec) == Money(1_000))
    #expect(sut.netIncome(at: 2025.jan) == Money(0))
  }

  @Test
  func scenario_for_distinct_streams() {
    let sut = makeScenario(
      makeLeia(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec),
      makeLeia(name: "Income2", 500, first: DateSpecifier.month(2024.oct), last: DateSpecifier.unchanged)
    )

    #expect(sut.netIncome(at: 2024.jan) == Money(1_000))
    #expect(sut.netIncome(at: 2024.oct) == Money(1_500))
    #expect(sut.netIncome(at: 2024.dec) == Money(1_500))
    #expect(sut.netIncome(at: 2025.jan) == Money(500))
  }

  @Test
  func scenario_for_merged_streams_with_last_date_unchanged() {
    let sut = makeScenario(
      makeLeia(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec),
      makeLeia(name: "Income1", 500, first: DateSpecifier.month(2024.oct), last: DateSpecifier.unchanged)
    )

    #expect(sut.netIncome(at: 2024.jan) == Money(0))
    #expect(sut.netIncome(at: 2024.oct) == Money(500))
    #expect(sut.netIncome(at: 2024.dec) == Money(500))
    #expect(sut.netIncome(at: 2025.jan) == Money(0))
  }

  @Test
  func scenario_for_merged_streams_with_first_date_unchanged() {
    let sut = makeScenario(
      makeLeia(name: "Income1", 1_000, first: 2024.feb, last: 2024.dec),
      makeLeia(name: "Income1", 500, first: DateSpecifier.unchanged, last: DateSpecifier.month(2026.jan))
    )

    #expect(sut.netIncome(at: 2024.jan) == Money(0))
    #expect(sut.netIncome(at: 2024.feb) == Money(500))
    #expect(sut.netIncome(at: 2024.dec) == Money(500))
    #expect(sut.netIncome(at: 2025.jan) == Money(500))
    #expect(sut.netIncome(at: 2026.jan) == Money(500))
    #expect(sut.netIncome(at: 2026.feb) == Money(0))
  }

  @Test
  func salary_minus_expenses_creates_net_worth() throws {
    let sut = makeScenario(
      makeLeia(name: "Salary", 1_000, first: DateSpecifier.unchanged, last: DateSpecifier.unchanged),
      makeLeia(name: "Expenses", -900, first: DateSpecifier.unchanged, last: DateSpecifier.unchanged)
    )

    let result = sut.netWorth(2024.jan...2024.dec)

    #expect(result.name == "Scenario Name")
    #expect(result.netWorthByMonth.last!.amount == Money(1_200))
  }
}
