import Foundation

@Observable
public class DateAssumptions {
  public static var shared = DateAssumptions()

  public var wasChanged = false
  private var assumptions = [DateAssumption]()

  public init() { }

  public func add(_ assumption: DateAssumption) {
    assumptions.append(assumption)
    wasChanged = true
  }

  public func find(_ name: String) -> DateAssumption? {
    assumptions.first { $0.name == name }
  }

  public func remove(_ name: String) {
    assumptions.removeAll { $0.name == name }
    wasChanged = true
  }

  public func replace(_ newAssumption: DateAssumption) {
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
}
