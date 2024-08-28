import Foundation

public enum AssumptionType: Codable {
  case percent
}

public struct PercentAssumption: Identifiable, Codable {
  public static var flatGrowth = "(none)"

  public static var null: PercentAssumption {
    PercentAssumption(type: .percent, name: "", min: 1, max: 100, current: 50)
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

  public init(_ assumption: PercentAssumption, _ newCurrent: Int) {
    self.type = assumption.type
    self.name = assumption.name
    self.min = assumption.min
    self.max = assumption.max

    self.current = newCurrent
  }
}

extension PercentAssumption: Comparable {
  public static func < (lhs: PercentAssumption, rhs: PercentAssumption) -> Bool {
    lhs.name < rhs.name
  }
}
