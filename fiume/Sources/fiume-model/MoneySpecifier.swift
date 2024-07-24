public enum MoneySpecifier: Equatable, Codable {
  case amount(Money)

  public func value() -> Money {
    switch self {
    case .amount(let amount):
      return amount
    }
  }
}
