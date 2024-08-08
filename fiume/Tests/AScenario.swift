@testable import fiume
import fiume_model
import Testing

extension Leia: Equatable {
  public static func == (lhs: Leia, rhs: Leia) -> Bool {
    lhs.name == rhs.name && lhs.amount == rhs.amount && lhs.dates == rhs.dates && lhs.type == rhs.type
  }
}

struct AScenario {
  private let people = People()

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: MonthYear,
    last: MonthYear
  ) -> Leia {
    Leia(name: name, amount: .money(amount), dates: DateRange(.month(first), .month(last)), leiaType: .income)
  }

  private func makeLeia(
    name: String = "Sample",
    _ amount: Int,
    first: DateSpecifier,
    last: DateSpecifier,
    leiaType: LeiaType = .income
  ) -> Leia {
    Leia(name: name, amount: .money(amount), dates: DateRange(first, last), leiaType: leiaType)
  }

  private func makeScenario(_ streams: Leia...) -> Scenario {
    let result = Scenario("Scenario Name", people: people)
    streams.forEach {
      result.add(stream: $0)
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
    result.add(stream: stream2)

    #expect(sut.netIncome(at: 2024.jan) == Money(1_000))
    #expect(result.netIncome(at: 2024.jan) == Money(3_000))
    #expect(result.name == "altered name")
  }

  @Test
  func computes_netIncome_for_one_stream() {
    let sut = makeScenario(
      makeLeia(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec)
    )

    #expect(sut.netIncome(at: 2024.dec) == Money(1_000))
    #expect(sut.netIncome(at: 2025.jan) == Money(0))
  }

  @Test
  func computes_netIncome_for_distinct_streams() {
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
  func retains_last_leia_with_duplicate_names() {
    let sut = makeScenario(
      makeLeia(name: "Salary", 1_000, first: 2020.jan, last: 2020.dec),
      makeLeia(name: "Salary", 2_000, first: .unchanged, last: .unchanged)
    )
    #expect(sut.find("Salary")!.amount(at: 2024.aug, people: People()) == 2_000)
  }

  @Test
  func computes_netWorth_from_salary_minus_expenses() throws {
    let sut = makeScenario(
      makeLeia(name: "Salary", 1_000, first: DateSpecifier.unchanged, last: DateSpecifier.unchanged),
      makeLeia(
        name: "Expenses",
        -900,
        first: DateSpecifier.unchanged,
        last: DateSpecifier.unchanged,
        leiaType: .expense
      )
    )

    let result = sut.netWorth(2024.jan...2024.dec)

    #expect(result.name == "Scenario Name")
    #expect(result.netWorthByMonth.last!.amount == Money(1_200))
  }

  @Test
  func keeps_pools_and_accumulates_streams() {
    let scenario = Scenario("pool+stream", people: people)
    let asset = Leia(name: "savings", amount: .money(1_000), dates: DateRange.always, leiaType: .asset)
    let income = Leia(name: "job", amount: .money(1), dates: DateRange.always, leiaType: .income)
    scenario.add(pool: asset)
    scenario.add(stream: income)

    let result = scenario.netWorth(2025.jan...2025.feb)

    #expect(result.netWorthByMonth[0].amount == 1001)
    #expect(result.netWorthByMonth[1].amount == 1002)
  }

  @Test
  func finds_named_stream() {
    let sut = Scenario("my scenario", people: People())
    let income = Leia(name: "job", amount: .money(1000), dates: DateRange.always, leiaType: .income)
    sut.add(stream: income)

    #expect(sut.find("job")!.amount.value() == Money(1000))
  }

  @Test
  func cant_find_missing_stream() {
    let sut = Scenario("my scenario", people: People())

    #expect(sut.find("missing stream") == nil)
  }

  @Test
  func calculates_relative_amount_of_a_stream() {
    let sut = Scenario("My scenario", people: People())
    let income = Leia(name: "job", amount: .money(1000), dates: DateRange.always, leiaType: .income)
    sut.add(stream: income)
    let relative = Leia(name: "rel", amount: .relative(0.5, "job"), dates: DateRange.always, leiaType: .income)
    sut.add(stream: relative)

    #expect(sut.netIncome(at: 2024.jan) == Money(1500))
  }

  @Test
  func calculates_relative_amount_of_a_pool() {
    let sut = Scenario("My scenario", people: People())
    let house = Leia(name: "house", amount: .money(100_000), dates: DateRange.always, leiaType: .asset)
    sut.add(pool: house)
    let relative = Leia(name: "rel", amount: .relative(0.5, "house"), dates: DateRange.always, leiaType: .asset)
    sut.add(pool: relative)

    #expect(sut.netAssets(at: 2024.jan) == Money(150_000))
  }
}
