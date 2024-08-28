import Foundation

@Observable
public class PercentAssumptions: Codable {
  public static var shared = PercentAssumptions()

  enum CodingKeys: String, CodingKey {
    case _wasChanged = "wasChanged"
    case _assumptions = "assumptions"
  }

  public var wasChanged = false
  public var assumptions: [PercentAssumption]

  public init() {
    assumptions = [PercentAssumption(type: .percent, name: "(none)", min: 0, max: 0, current: 0)]
  }

  public func load(_ original: PercentAssumptions) {
    assumptions = original.assumptions
    wasChanged = false
  }

  public func add(_ assumption: PercentAssumption) {
    assumptions.append(assumption)
    wasChanged = true
  }

  public func find(_ name: String) -> PercentAssumption? {
    assumptions.first { $0.name == name }
  }

  public func findMonthlyRate(_ name: String?) -> Double {
    guard name != nil, let assumption = find(name!) else {
      return 0.0
    }
    return pow(1 + Double(assumption.current) / 100.0, 1.0 / 12.0)
  }

  public func remove(_ name: String) {
    assumptions.removeAll { $0.name == name }
    wasChanged = true
  }

  public func replace(_ assumption: PercentAssumption) {
    remove(assumption.name)
    add(assumption)
    wasChanged = true
  }

  public func verified(_ name: String) -> String {
    guard find(name) != nil else {
      return PercentAssumption.flatGrowth
    }
    return name
  }
}

extension PercentAssumptions: Sequence {
  public func makeIterator() -> some IteratorProtocol<PercentAssumption> {
    assumptions
      .sorted(by: { $0.name < $1.name })
      .makeIterator()
  }
}
