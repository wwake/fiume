enum DateSpecifier: Equatable, Codable {
  case unchanged
  case month(MonthYear)
  case age(String, MonthYear, Int)

  func update(using: DateSpecifier) -> DateSpecifier {
    switch using {
    case .unchanged:
      return self

    case .month, .age:
      return using
    }
  }
}

extension DateSpecifier: CustomStringConvertible {
  var description: String {
    switch self {
    case .unchanged:
      return "(unchanged)"

    case .month(let monthYear):
      return monthYear.description

    case let .age(name, _, age):
      return "\(name)@\(age)"
    }
  }
}
