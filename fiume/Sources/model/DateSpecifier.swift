enum DateSpecifier: Equatable {
  case unchanged
  case month(Int)

  func update(using: DateSpecifier) -> DateSpecifier {
    switch using {
    case .unchanged:
      return self

    case .month:
      return using
    }
  }
}
