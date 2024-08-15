import Foundation

@Observable
public class Assumptions: Codable {
  enum CodingKeys: String, CodingKey {
    case _assumptions = "assumptions"
  }

  public var assumptions: [Assumption]

  public init() {
    assumptions = [Assumption(type: .percent, name: "(none)", min: 0, max: 0, current: 0)]
  }

  public func load(_ original: Assumptions) {
    assumptions = original.assumptions
  }

  public func add(_ assumption: Assumption) {
    assumptions.append(assumption)
  }

  public func find(_ name: String) -> Assumption? {
    assumptions.first { $0.name == name }
  }

  public func remove(_ name: String) {
    assumptions.removeAll { $0.name == name }
  }

  public func replace(_ assumption: Assumption) {
    remove(assumption.name)
    add(assumption)
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
