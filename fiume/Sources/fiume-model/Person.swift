import Foundation

public struct Person: Identifiable, Equatable, Codable {
  public static var null: Person {
    Person(name: "", birth: 2000.jun)
  }

  public var id: UUID
  public let name: String
  public let birth: MonthYear

  public init(_ id: UUID = UUID(), name: String, birth: MonthYear) {
    self.id = id
    self.name = name
    self.birth = birth
  }
}

extension Person: Hashable {
  public static func == (lhs: Person, rhs: Person) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}

extension Person: Comparable {
  public static func < (lhs: Person, rhs: Person) -> Bool {
    if lhs.name == rhs.name {
      return lhs.birth < rhs.birth
    }
    return lhs.name < rhs.name
  }
}
