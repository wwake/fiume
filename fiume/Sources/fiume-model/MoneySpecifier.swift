public enum MoneySpecifier: Equatable {
  case amount(Money)

  public func value() -> Money {
    switch self {
    case .amount(let amount):
      return amount
    }
  }
}

extension MoneySpecifier: Codable { }
