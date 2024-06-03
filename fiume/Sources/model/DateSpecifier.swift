enum DateSpecifier: Equatable {
  case unchanged
  case month(MonthNumber)
  case age(Person, Int)

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

    case .month(let month):
      return "\(month)"

    case let .age(person, age):
      return "\(person.name)@\(age)"
    }
  }
}
