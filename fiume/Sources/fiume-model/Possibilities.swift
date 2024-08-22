import Foundation

public struct MonthlyNetWorth: Identifiable {
  public let id = UUID()
  public let month: MonthYear
  public let amount: Money
}

public struct ScenarioNetWorth: Identifiable {
  public let id = UUID()
  public let name: String
  public let netWorthByMonth: [MonthlyNetWorth]
}

public typealias PossibilitiesNetWorth = [ScenarioNetWorth]

@Observable
public class Possibilities {
  enum CodingKeys: String, CodingKey {
    case _startMonth = "startMonth"
    case _plans = "plans"
    case _people = "people"
  }

  public let startMonth: MonthYear

  public var plans: [Plan]

  public init(startDate: MonthYear, plans: Plans) {
    self.startMonth = startDate
    self.plans = [plans.plans]
  }

  public func range(_ numberOfMonths: Int) -> ClosedRange<MonthYear> {
    startMonth.range(numberOfMonths)
  }

  public func netWorth(_ range: ClosedRange<MonthYear>) -> PossibilitiesNetWorth {
    scenarios()
      .map {
        $0.netWorth(range)
      }
	}

  public func scenarios() -> Scenarios {
    plans[0].scenarios(Scenarios([Scenario("Scenario")]))
	}
}
