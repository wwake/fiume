import Foundation

public class Scenario: Identifiable {
  public let id = UUID()
  public let name: String
  public let people: People

  fileprivate typealias NameToLeia = [String: Leia]
  private var leias = NameToLeia()

  public init(_ name: String, people: People) {
    self.name = name
    self.people = people
  }

  private convenience init(_ other: Scenario, _ newName: String) {
    self.init(newName, people: other.people)
    let copy = other.leias
    self.leias = copy
  }

  public func copy(_ newName: String) -> Scenario {
    Scenario(self, newName)
  }

  public func add(_ leia: Leia) {
    leias[leia.name] = leia
  }

  public func netWorth(_ range: ClosedRange<MonthYear>) -> ScenarioNetWorth {
    var result = [MonthlyNetWorth]()
    var netIncomeToDate = Money(0)
    range.forEach { monthYear in
      let netIncomeForMonth = netIncome(at: monthYear)
      netIncomeToDate += netIncomeForMonth

      let netAssetsAtMonth = netAssets(at: monthYear)
      let netWorthAtMonth = netIncomeToDate + netAssetsAtMonth

      let extractedExpr: MonthlyNetWorth = MonthlyNetWorth(month: monthYear, amount: netWorthAtMonth)
      result.append(extractedExpr)
    }
    return ScenarioNetWorth(name: name, netWorthByMonth: result)
  }

  public func find(_ name: String) -> Leia? {
    leias[name]
  }

  fileprivate func filterBy(_ type1: LeiaType, _ type2: LeiaType) -> NameToLeia {
    leias.filter { _, value in
      value.type == type1 || value.type == type2
    }
  }

  public func netIncome(at month: MonthYear) -> Money {
    net(at: month, in: filterBy(.income, .expense))
  }

  public func netAssets(at month: MonthYear) -> Money {
    net(at: month, in: filterBy(.asset, .liability))
  }

  fileprivate func net(at month: MonthYear, in collection: NameToLeia) -> Money {
    collection.values.reduce(Money(0)) { net, leia in
      net + leia.signedAmount(at: month, people: people, scenario: self)
    }
  }
}

extension Scenario: Hashable {
  public static func == (lhs: Scenario, rhs: Scenario) -> Bool {
    lhs.id == rhs.id
	}

  public func hash(into hasher: inout Hasher) {
			hasher.combine(id)
	}
}
