import Foundation

@Observable
public class DateAssumptions {
  public static var shared = DateAssumptions()

  public var wasChanged = false
  private var assumptions = // [Assumption]()
  [
    Assumption(type: .date, name: "default", min: 1900, max: 2200, current: 2020),
    Assumption.nullDate,
  ]

  public init() { }

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

  public func replace(_ newAssumption: Assumption) {
    remove(newAssumption.name)
    add(newAssumption)
    wasChanged = true
  }

  public func current(_ name: String) -> MonthYear {
    guard let assumption = find(name) else {
      return 1900.jan
    }
    return MonthYear(.jan, assumption.current)
  }

  public var count: Int {
    assumptions.count
  }

  public var names: [String] {
    Array(self)
      .map { $0.name }
  }

  public var firstName: String? {
    names.first
  }
}

extension DateAssumptions: Sequence {
  public func makeIterator() -> some IteratorProtocol<Assumption> {
    assumptions
      .sorted(by: { $0.name < $1.name })
      .makeIterator()
  }
}
