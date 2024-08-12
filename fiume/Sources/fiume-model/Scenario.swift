import Foundation

public class Scenario: Identifiable {
  public let id = UUID()
  public let name: String
  public let people: People

  public typealias NameToLeia = [String: Leia]
  private var streams = NameToLeia()
  private var pools = NameToLeia()

  public init(_ name: String, people: People) {
    self.name = name
    self.people = people
  }

  private convenience init(_ other: Scenario, _ newName: String) {
    self.init(newName, people: other.people)
    let copy = other.streams
    self.streams = copy
  }

  public func copy(_ newName: String) -> Scenario {
    Scenario(self, newName)
  }

  public func add(pool: Leia) {
    add(pool, &pools)
  }

  public func add(stream: Leia) {
    add(stream, &streams)
  }

  fileprivate func add(_ leia: Leia, _ map: inout NameToLeia) {
    map[leia.name] = leia
  }

  public func netWorth(_ range: ClosedRange<MonthYear>) -> ScenarioNetWorth {
    var result = [MonthlyNetWorth]()
    var netIncomeToDate = Money(0)
    range.forEach { monthYear in
      let netIncomeForMonth = netIncome(at: monthYear)
      netIncomeToDate += netIncomeForMonth

      let netAssetsAtMonth = netAssets(at: monthYear)
      let netWorthAtMonth = netIncomeToDate + netAssetsAtMonth

      result.append(MonthlyNetWorth(month: monthYear, amount: netWorthAtMonth))
    }
    return ScenarioNetWorth(name: name, netWorthByMonth: result)
  }

  public func find(_ name: String) -> Leia? {
    streams[name] ?? pools[name]
  }

  private var leias: NameToLeia {
    streams.merging(pools) { value1, _ in
      value1
    }
  }

  public func netIncome(at month: MonthYear) -> Money {
    net(at: month, in: leias.filter { _, value in
      value.type == .income || value.type == .expense
    })
  }

  public func netAssets(at month: MonthYear) -> Money {
    net(at: month, in: leias.filter { _, value in
      value.type == .asset || value.type == .liability
    })
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
