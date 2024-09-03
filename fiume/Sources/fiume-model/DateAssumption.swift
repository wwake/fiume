public struct Assumption2: Identifiable {
  public static var nullDate = {
    Assumption2("<none>", min: 0, max: 9999, current: 2000)
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

  public init(_ base: Assumption2, _ newCurrent: Int) {
    self = base
    self.current = newCurrent
  }
}

extension Assumption2: Hashable {
  public static func == (lhs: Assumption2, rhs: Assumption2) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}
