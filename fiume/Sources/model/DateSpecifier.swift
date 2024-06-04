enum DateSpecifier: Equatable {
  case unchanged
  case month_(MonthNumber)
  case month(MonthYear)
  case age(Person, Int)

  func update(using: DateSpecifier) -> DateSpecifier {
    switch using {
    case .unchanged:
      return self

    case .month_, .month, .age:
      return using
    }
  }
}

extension DateSpecifier: CustomStringConvertible {
  var description: String {
    switch self {
    case .unchanged:
      return "(unchanged)"

    case .month_(let month):
      return "\(month)"

    case .month(let monthYear):
      return monthYear.description

    case let .age(person, age):
      return "\(person.name)@\(age)"
    }
  }
}
