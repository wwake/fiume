public struct DateAssumption {
  public var name: String
  public var min: Int
  public var max: Int
  public var current: Int

  public init(_ name: String, min: Int, max: Int, current: Int) {
    self.name = name
    self.min = min
    self.max = max
    self.current = current
  }

  public init(_ base: DateAssumption, _ newCurrent: Int) {
    self = base
    self.current = newCurrent
  }
}
