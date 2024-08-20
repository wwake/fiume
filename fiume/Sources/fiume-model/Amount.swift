import Foundation

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

  fileprivate func principalPlusInterest(_ amount: (Money), _ monthlyInterest: Double?, _ start: MonthYear?, _ at: MonthYear) -> Money {
    let numberOfMonths = Double(start!.distance(to: at))
    let rateFactor = pow(1 + monthlyInterest!, numberOfMonths)
    return Money(Double(amount) * rateFactor)
  }

  public func value(
    monthlyInterest: Double,
    start: MonthYear? = nil,
    at: MonthYear,
    _ people: People,
    _ scenario: Scenario
  ) -> Money {
    switch self {
    case .money(let amount):
      if monthlyInterest == 0.0 || start == nil {
        return amount
      } else {
        return principalPlusInterest(amount, monthlyInterest, start, at)
      }

    case let .relative(ratio, leiaName):
      let base = scenario.find(leiaName)
      guard base != nil else {
        return Money(0)
      }
      return Money(ratio * Double(base!.signedAmount(at: at, people: people, scenario: scenario)))
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
