public enum Amount: Equatable {
  case money(Money)

  public func value() -> Money {
    switch self {
    case .money(let amount):
      return amount
    }
  }
}

extension Amount: Codable { }
