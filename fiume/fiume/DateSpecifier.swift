enum DateSpecifier {
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
