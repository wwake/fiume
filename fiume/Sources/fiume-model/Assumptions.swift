import Foundation

@Observable
public class Assumptions {
  public var assumptions: [Assumption]

  public init() {
    assumptions = [Assumption.percent("ROI", 0.0, 8.0, 15.0)]
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
