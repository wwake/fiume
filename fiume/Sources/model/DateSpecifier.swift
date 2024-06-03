enum DateSpecifier: Equatable {
  case unspecified
  case month(Int)

  func update(using: DateSpecifier) -> DateSpecifier {
    switch using {
    case .unspecified:
      return self

    case .month:
      return using
    }
  }
}
