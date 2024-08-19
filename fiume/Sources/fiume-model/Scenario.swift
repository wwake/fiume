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

  public func find(_ name: String) -> Leia? {
    leias[name]
  }

  public func netWorth(_ range: ClosedRange<MonthYear>) -> ScenarioNetWorth {
    NetWorth(
      scenario: self,
      leias: leias.values,
      range: range
    ).compute()
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
