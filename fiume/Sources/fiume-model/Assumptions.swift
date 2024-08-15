import Foundation

@Observable
public class Assumptions {
  public var assumptions: [Assumption]

  public init() {
    assumptions = [Assumption(type: .percent, name: "(none)", min: 0, max: 0, current: 0)]
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
}

extension Assumptions: Sequence {
  public func makeIterator() -> some IteratorProtocol<Assumption> {
    assumptions
      .makeIterator()
  }
}

extension Assumptions {
  func sorted() -> [Assumption] {
    Array(self).sorted(by: { $0.name < $1.name })
  }
}
