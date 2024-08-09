public enum Amount: Equatable {
  enum CodingKeys: String, CodingKey {
    case money = "amount"
    case relative
  }

  case money(Money)
  case relative(Double, String)

  public init(_ money: Money) {
    self = .money(money)
  }

  public init(_ ratio: Double, _ name: String) {
    self = .relative(ratio, name)
  }

  public var isNonNegative: Bool {
    switch self {
    case .money(let amount):
      return amount >= 0

    case .relative:
      return true
    }
  }

  public func value(at: MonthYear? = nil, _ people: People, _ scenario: Scenario? = nil) -> Money {
    switch self {
    case .money(let amount):
      return amount

    case let .relative(ratio, leiaName):
      let base = scenario!.find(leiaName)
      guard at != nil && base != nil else {
        return Money(0)
      }
      return Money(ratio * Double(base!.amount(at: at!, people: people, scenario: scenario!)))
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
      return "\(ratio.formatted(.percent.precision(.fractionLength(0)))) of \(streamName)"
    }
  }
}
