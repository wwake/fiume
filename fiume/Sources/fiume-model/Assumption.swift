import Foundation

public enum AssumptionType {
  case percent
}

public struct Assumption: Identifiable {
  public var id = UUID()
  public var type: AssumptionType
  public var name: String

  public var min: Int
  public var current: Int
  public var max: Int

  public init(id: UUID = UUID(), type: AssumptionType, name: String, min: Int, max: Int, current: Int) {
    self.id = id
    self.type = type
    self.name = name
    self.min = min
    self.max = max
    self.current = current
  }
}
