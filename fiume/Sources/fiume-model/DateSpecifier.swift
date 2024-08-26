import Foundation

public enum DateSpecifier: Equatable, Codable {
  case unchanged
  case month(MonthYear)
  case age(UUID, Int)

  public func update(using: DateSpecifier) -> DateSpecifier {
    switch using {
    case .unchanged:
      return self

    case .month, .age:
      return using
    }
  }

  private var people: People {
    People.shared
  }

  public var description: String {
    switch self {
    case .unchanged:
      return ""

    case .month(let monthYear):
      return monthYear.description

    case let .age(id, age):
      let person = people.findById(id)
      let name = person?.name ?? "<person not found>"
      return "\(name)@\(age)"
    }
  }

  public var effectiveStart: MonthYear {
    switch self {
    case .unchanged:
      return 1900.jan

    case .month(let monthYear):
      return monthYear

    case let .age(id, age):
      guard let person = people.findById(id) else { return 9999.dec }
      let birth = person.birth
      return birth.advanced(byYears: age)
    }
  }

  public func leq(_ monthYear: MonthYear) -> Bool {
    effectiveStart <= monthYear
  }

  public func geq(_ monthYear: MonthYear) -> Bool {
    switch self {
    case .unchanged:
      return true

    case .month(let endMonth):
      return endMonth >= monthYear

    case let .age(id, age):
      guard let person = people.findById(id) else { return false }
      let birth = person.birth
      let effectiveEnd = birth.advanced(byYears: age)
      return effectiveEnd > monthYear
    }
  }
}
