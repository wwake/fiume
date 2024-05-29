enum DateSpecifier: Equatable {
  case unspecified
  case month(Int)

  func asOptionalInt() -> Int? {
    switch self {
    case .unspecified:
      return nil

    case .month(let monthNumber):
      return monthNumber
    }
  }
}

extension DateSpecifier: CustomDebugStringConvertible {
  var debugDescription: String {
    switch self {
    case .unspecified:
      return "?"

    case .month(let monthNumber):
      return "\(monthNumber)"
    }
  }
}
