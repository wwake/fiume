import Foundation

@Observable
public class Assumptions {
  public var assumptions: [Assumption]

  public init() {
    assumptions = [Assumption(type: .percent, name: "ROI", min: 0, max: 8, current: 5)]
  }

  public func add(_ assumption: Assumption) {
    assumptions.append(assumption)
  }

  public func find(_ name: String) -> Assumption? {
    assumptions.first { $0.name == name }
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
