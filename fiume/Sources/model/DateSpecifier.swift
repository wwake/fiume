enum DateSpecifier: Equatable {
  case unchanged
  case month(MonthNumber)
  case age(String, Int)

  func update(using: DateSpecifier) -> DateSpecifier {
    switch using {
    case .unchanged:
      return self

    case .month, .age:
      return using
    }
  }
}
