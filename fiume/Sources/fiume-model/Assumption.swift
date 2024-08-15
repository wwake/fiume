import Foundation

public enum AssumptionType {
  case percent
}

public struct Assumption: Identifiable {
  public static var flatGrowth = "(none)"

  public static var null: Assumption {
    Assumption(type: .percent, name: "", min: 1, max: 100, current: 50)
  }

  public var id = UUID()
  public var type: AssumptionType
  public var name: String

  public var min: Int
  public var max: Int
  public var current: Int

  public init(type: AssumptionType, name: String, min: Int, max: Int, current: Int) {
    self.type = type
    self.name = name
    self.min = min
    self.max = max
    self.current = current
  }

  public init(_ assumption: Assumption, _ newCurrent: Int) {
    self.type = assumption.type
    self.name = assumption.name
    self.min = assumption.min
    self.max = assumption.max

    self.current = newCurrent
  }
}

extension Assumption: Comparable {
  public static func < (lhs: Assumption, rhs: Assumption) -> Bool {
    lhs.name < rhs.name
  }
}
