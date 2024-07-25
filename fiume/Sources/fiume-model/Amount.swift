public enum Amount: Equatable {
  case money(Money)
  case relative(Double, String)

  public func value(_ scenario: Scenario? = nil) -> Money {
    switch self {
    case .money(let amount):
      return amount

    case let .relative(ratio, streamName):
      return Money(52)
    }
  }

  public init(_ money: Money) {
    self = .money(money)
  }

  public init(_ ratio: Double, _ streamName: String) {
    self = .relative(ratio, streamName)
  }
}

extension Amount: Codable { }
