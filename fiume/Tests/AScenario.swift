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
  let ignoredScenario = Scenario("ignored", people: People())

  static func makeScenario(_ streams: Leia...) -> Scenario {
    let result = Scenario("Scenario Name", people: People())
    streams.forEach {
      result.add($0)
    }
    return result
  }

  @Test
  func makes_independent_copies() {
    let sut = Self.makeScenario(
      makeLeia(name: "Income1", 1_000, first: 2024.jan, last: 2024.dec, .income)
    )

    let result = sut.copy("altered name")
    let stream2 = makeLeia(name: "Income2", 2_000, first: 2024.jan, last: 2024.dec, .income)
    result.add(stream2)

    #expect(netWorth(sut, 2024.jan) == Money(1_000))
    #expect(netWorth(result, 2024.jan) == Money(3_000))
    #expect(result.name == "altered name")
  }

  @Test
  func retains_last_leia_with_duplicate_names() {
    let sut = Self.makeScenario(
      makeLeia(name: "Salary", 1_000, first: 2020.jan, last: 2020.dec, .income),
      makeLeia(name: "Salary", 2_000, first: .unchanged, last: .unchanged, leiaType: .income)
    )
    #expect(sut.find("Salary")!.signedAmount(at: 2024.aug, people: People(), scenario: ignoredScenario) == 2_000)
  }

  @Test
  func computes_netWorth_from_salary_minus_expenses() throws {
    let sut = Self.makeScenario(
      makeLeia(name: "Salary", 1_000, first: DateSpecifier.unchanged, last: DateSpecifier.unchanged),
      makeLeia(
        name: "Expenses",
        900,
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
    let asset = makeLeia(name: "savings", 1_000, leiaType: .asset)
    let income = makeLeia(name: "job", 1, leiaType: .income)
    scenario.add(asset)
    scenario.add(income)

    let result = scenario.netWorth(2025.jan...2025.feb)

    #expect(result.netWorthByMonth[0].amount == 1001)
    #expect(result.netWorthByMonth[1].amount == 1002)
  }

  @Test
  func finds_named_stream() {
    let sut = Scenario("my scenario", people: People())
    let income = makeLeia(name: "job", 1000)
    sut.add(income)

    #expect(sut.find("job")!.amount.value(monthlyInterest: 0.0, at: 2024.dec, People(), ignoredScenario) == Money(1000))
  }

  @Test
  func cant_find_missing_stream() {
    let sut = Scenario("my scenario", people: People())

    #expect(sut.find("missing stream") == nil)
  }

  @Test
  func calculates_relative_amount_of_a_stream() {
    let sut = Scenario("My scenario", people: People())
    let income = makeLeia(name: "job", 1000)
    sut.add(income)
    let relative = Leia(
      name: "rel",
      amount: .relative(0.5, "job"),
      dates: DateRange.always,
      type: .income,
      growth: Assumption.flatGrowth
    )
    sut.add(relative)

    #expect(netWorth(sut, 2024.jan) == Money(1500))
  }

  @Test
  func calculates_relative_amount_of_a_pool() {
    let sut = Scenario("My scenario", people: People())
    let house = makeLeia(name: "house", 100_000, leiaType: .asset)
    sut.add(house)
    let relative = Leia(
      name: "rel",
      amount: .relative(0.5, "house"),
      dates: DateRange.always,
      type: .asset,
      growth: Assumption.flatGrowth
    )
    sut.add(relative)

    #expect(netWorth(sut, 2024.jan) == Money(150_000))
  }
}
