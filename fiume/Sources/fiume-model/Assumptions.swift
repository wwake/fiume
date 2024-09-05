import Foundation

public struct AssumptionsSection: Identifiable {
  public var id = UUID()

  public let type: AssumptionType
  public let iconName: String
  public let name: String

  public init(_ type: AssumptionType, _ iconName: String, _ name: String) {
    self.type = type
    self.iconName = iconName
    self.name = name
  }
}

@Observable
public class Assumptions: Codable {
  public static var shared = Assumptions()

  enum CodingKeys: String, CodingKey {
    case _wasChanged = "wasChanged"
    case _assumptions = "assumptions"
  }

  public var wasChanged = false
  public var assumptions: [Assumption]

  public init() {
    assumptions = [Assumption(type: .percent, name: "(none)", min: 0, max: 0, current: 0)]
  }

  public var sections: [AssumptionsSection] = [
    AssumptionsSection(.percent, "percent", "Annual Percentage Rate"),
    AssumptionsSection(.date, "calendar", "Date"),
  ]

  public func load(_ original: Assumptions) {
    assumptions = original.assumptions
    wasChanged = false
  }

  public func add(_ assumption: Assumption) {
    assumptions.append(assumption)
    wasChanged = true
  }

  public func find(_ name: String) -> Assumption? {
    assumptions.first { $0.name == name }
  }

  public func remove(_ name: String) {
    assumptions.removeAll { $0.name == name }
    wasChanged = true
  }

  public func replace(_ assumption: Assumption) {
    remove(assumption.name)
    add(assumption)
    wasChanged = true
  }

  public func verified(_ name: String) -> String {
    guard find(name) != nil else {
      return Assumption.defaultGrowth
    }
    return name
  }

  public func count(_ type: AssumptionType) -> Int {
    filter(type).count
  }

  public func names(_ type: AssumptionType) -> [String] {
    filter(type)
      .map { $0.name }
      .sorted()
  }

  public func filter(_ type: AssumptionType) -> [Assumption] {
    assumptions
      .filter { $0.type == type }
  }

  public func asMonthYear(_ name: String) -> MonthYear {
    guard let assumption = find(name) else {
      return 1900.jan
    }
    return MonthYear(.jan, assumption.current)
  }

  public func findMonthlyRate(_ name: String?) -> Double {
    guard name != nil, let assumption = find(name!) else {
      return 0.0
    }
    return pow(1 + Double(assumption.current) / 100.0, 1.0 / 12.0)
  }
}

extension Assumptions: Sequence {
  public func makeIterator() -> some IteratorProtocol<Assumption> {
    assumptions
      .sorted(by: { $0.name < $1.name })
      .makeIterator()
  }
}
