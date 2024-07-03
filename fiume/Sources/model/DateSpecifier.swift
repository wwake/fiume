import Foundation

enum DateSpecifier: Equatable, Codable {
  case unchanged
  case month(MonthYear)
  case age(UUID, Int)

  func update(using: DateSpecifier) -> DateSpecifier {
    switch using {
    case .unchanged:
      return self

    case .month, .age:
      return using
    }
  }
}

extension DateSpecifier {
  func description(_ people: People) -> String {
    switch self {
    case .unchanged:
      return "(unchanged)"

    case .month(let monthYear):
      return monthYear.description

    case let .age(id, age):
      let person = people.findById(id)
      let name = person?.name ?? "<person not found>"
      return "\(name)@\(age)"
    }
  }
}
