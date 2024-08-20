import Foundation

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

  public func findPercent(_ name: String?) -> Double {
    guard name != nil, let assumption = find(name!) else {
      return 0.0
    }
    return Double(assumption.current) / 100.0
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
      return Assumption.flatGrowth
    }
    return name
  }
}

extension Assumptions: Sequence {
  public func makeIterator() -> some IteratorProtocol<Assumption> {
    assumptions
      .sorted(by: { $0.name < $1.name })
      .makeIterator()
  }
}
