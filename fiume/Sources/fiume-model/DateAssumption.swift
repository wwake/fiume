public struct DateAssumption: Identifiable {
  public static var null = {
    DateAssumption("<none>", min: 0, max: 9999, current: 2000)
  }()

  public var id = UUID()

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

extension DateAssumption: Hashable {
  public static func == (lhs: DateAssumption, rhs: DateAssumption) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}
