@testable import fiume
import fiume_model
import Testing

struct ThePossibilities {
  private let people = People()

  private func makeLeia(_ name: String, _ amount: Int, _ leiaType: LeiaType = .income) -> Leia {
    Leia(
      name: name,
      amount: .money(amount),
      dates: DateRange(.month(2024.jan), .unchanged),
      type: leiaType,
      growth: Assumption.defaultGrowth
    )
  }

  private func makePossibilities() -> Possibilities {
    let plans = Plans()
    return Possibilities(startDate: 2030.jan, plans: plans)
  }

  @Test
	func salary_builds_net_worth() throws {
		let sut = makePossibilities()
		sut.add(makeLeia("Salary", Money(1_000)))

    let data = sut.summary(sut.range(12))

    #expect(data[0].netWorthByMonth.last!.netWorth == Money(12_000))
	}

  @Test
	func salary_minus_expenses_creates_net_worth() throws {
		let sut = makePossibilities()
    sut.add(makeLeia("Salary", Money(1_000), .income))
    sut.add(makeLeia("Expenses", Money(900), .expense))

		let data = sut.summary(sut.range(12))

    #expect(data[0].netWorthByMonth.last!.netWorth == Money(1_200))
	}

  @Test
  func scenarios_start_with_empty_name() {
    let sut = makePossibilities()
    let scenarios = sut.scenarios()
    scenarios.forEach {
      #expect($0.name == "Scenario")
    }
  }

  @Test
  func scenarios_with_only_groups() {
		let sut = makePossibilities()
    sut.add(makeLeia("Salary", Money(1_000), .income))
    sut.add(makeLeia("Expenses", Money(900), .expense))

    let result = Array(sut.scenarios())

		#expect(result.count == 1)
    #expect(netWorth(result.first!, 2024.jan) == Money(100))
	}

  @Test
  func adds_scenarios() {
    let sut = makePossibilities()

    let orTree = Plan.makeScenarios("jobs")
    orTree.append(Plan.make(makeLeia("Salary1", Money(1_000))))
    orTree.append(Plan.make(makeLeia("Salary2", Money(2_000))))
    sut.add(orTree)

    #expect(sut.scenarios().count == 2)
  }

  @Test
  func computes_net_worth_for_multiple_scenarios() {
    let sut = makePossibilities()
    let orTree = Plan.makeScenarios("jobs")
    orTree.append(Plan.make(makeLeia("Salary1", Money(1_000))))
    orTree.append(Plan.make(makeLeia("Salary2", Money(2_000))))
    sut.add(orTree)

    let result = sut.summary(sut.range(3))
    let resultSet = Set([
      result[0].netWorthByMonth.last!.netWorth,
      result[1].netWorthByMonth.last!.netWorth,
    ])
    #expect(resultSet == [3_000, 6_000])
  }
}
