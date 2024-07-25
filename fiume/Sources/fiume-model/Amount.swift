public enum Amount: Equatable {
  case money(Money)
  case relative(Double, String)

  public init(_ money: Money) {
    self = .money(money)
  }

  public init(_ ratio: Double, _ streamName: String) {
    self = .relative(ratio, streamName)
  }

  public func value(at: MonthYear? = nil, _ scenario: Scenario? = nil) -> Money {
    switch self {
    case .money(let amount):
      return amount

    case let .relative(ratio, streamName):
      let base = scenario!.find(stream: streamName)
      guard at != nil && base != nil else {
        return Money(0)
      }
      return Money(ratio * Double(base!.amount(at: at!, people: People(), scenario: scenario!)))
    }
  }
}

extension Amount: Codable { }

extension Amount: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .money(amount):
      return "$\(amount)/mo"

    case let .relative(ratio, streamName):
      return "\(ratio) of \(streamName)"
    }
  }
}
