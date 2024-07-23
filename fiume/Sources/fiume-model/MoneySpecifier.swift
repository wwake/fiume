public enum MoneySpecifier {
  case amount(Money)

  public func value() -> Money {
    switch self {
    case .amount(let amount):
      return amount
    }
  }
}
