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

  public func description(_ people: People) -> String {
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

  public func leq(_ monthYear: MonthYear, _ people: People) -> Bool {
    switch self {
    case .unchanged:
      return true

    case let .month(startMonth):
      return startMonth <= monthYear

    case let .age(id, age):
      guard let person = people.findById(id) else { return false }
      let birth = person.birth
      let effectiveStart = birth.advanced(byYears: age)
      return effectiveStart <= monthYear
    }
  }

  public func geq(_ monthYear: MonthYear, _ people: People) -> Bool {
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
