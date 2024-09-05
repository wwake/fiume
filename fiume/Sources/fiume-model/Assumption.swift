import Foundation

public enum AssumptionType: Codable {
  case percent
  case date
}

public struct Assumption: Identifiable, Codable {
  public static func null(_ type: AssumptionType) -> Assumption {
    switch type {
    case .percent:
      return Assumption.null

    case .date:
      return Assumption.nullDate
    }
  }

  public static var defaultGrowth = "(default)"

  public static var null: Assumption {
    Assumption(type: .percent, name: "", min: 1, max: 100, current: 50)
  }

  public static var nullDate = {
    Assumption(type: .date, name: "", min: 0, max: 9999, current: 2000)
  }()

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

  public init(_ base: Assumption, _ newCurrent: Int) {
    self = base
    self.current = newCurrent
  }
}

extension Assumption: Comparable {
  public static func < (lhs: Assumption, rhs: Assumption) -> Bool {
    lhs.name < rhs.name
  }
}

extension Assumption: Hashable {
  public static func == (lhs: Assumption, rhs: Assumption) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}
