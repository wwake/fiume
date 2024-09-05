import Foundation

public enum DateSpecifierType: String, CaseIterable, Identifiable {
  public var id: Self { self }

  case unchanged = "Unspecified",
       monthYear = "Month-Year",
       age = "Age",
       assumption = "Assumed Date"
}

public enum DateSpecifier: Equatable, Codable {
  case unchanged
  case month(MonthYear)
  case age(UUID, Int)
  case assumption(String)

  private var people: People {
    People.shared
  }

  public var type: DateSpecifierType {
    switch self {
    case .unchanged:
      return .unchanged

    case .month:
      return .monthYear

    case .age:
      return .age

    case .assumption:
      return .assumption
    }
  }

  public var assumedDateName: String? {
    switch self {
    case .assumption(let dateName):
      return dateName

    default:
      return nil
    }
  }

  public var monthYear: MonthYear? {
    if case let .month(monthYear) = self {
      return monthYear
    }
    return nil
  }

  public var ageId: UUID? {
    if case let .age(id, _) = self {
      return id
    }
    return nil
  }

  public var ageYears: Int? {
    if case let .age(_, years) = self {
      return years
    }
    return nil
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

    case .assumption(let name):
      guard let assumption = Assumptions.shared.find(name) else {
        return "<Assumed date '\(name)' not found>"
      }
      return "Jan \(assumption.current) (\(name))"
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

    case .assumption(let name):
      return Assumptions.shared.asMonthYear(name)
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

    case .assumption(let name):
      let effectiveEnd = Assumptions.shared.asMonthYear(name)
      return effectiveEnd >= monthYear
    }
  }
}
