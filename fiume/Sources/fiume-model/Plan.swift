import Foundation

public enum PlanType: String, CaseIterable, Identifiable, Codable {
  public var id: Self { self }

  case pool, stream, leia, group, scenarios
}

@Observable
public class Plan: Identifiable, Codable {
  enum CodingKeys: String, CodingKey {
    case _id = "id"
    case _type = "type"
    case _name = "name"
    case _leia = "leia"
    case _children = "children"
  }

  public var id = UUID()

  public var type: PlanType

  public private(set) var name: String

  public var leia: Leia?

  public var children: [Plan]?

  public static func make(_ leia: Leia) -> Plan {
    Plan(.leia, leia)
  }

  public static func makeGroup(_ name: String) -> Plan {
    Plan(.group, name)
  }

  public static func makeScenarios(_ name: String) -> Plan {
    Plan(.scenarios, name)
  }

  fileprivate init(_ type: PlanType, _ leia: Leia) {
    self.type = type
    self.name = leia.name
    self.leia = leia
  }

  fileprivate init(_ type: PlanType, _ name: String) {
    self.type = type
    self.name = name
    self.children = []
  }

  public func append(_ child: Plan) {
    if children == nil {
      children = [child]
    } else {
      children!.append(child)
    }
  }

  public func update() {
    switch type {
    case .pool, .stream, .leia:
      type = .leia
      leia = Leia(
        name: leia!.name,
        amount: leia!.amount,
        dates: leia!.dates_,
        type: leia!.type,
        growth: leia!.growth ?? "(none)"
      )

    case .group, .scenarios:
      if children != nil {
        children!.forEach {
          $0.update()
        }
      }
    }
  }

  public func remove(_ descendant: Plan) {
    guard children != nil else { return }
    children!.removeAll(where: { $0.id == descendant.id })
    children!.forEach {
      $0.remove(descendant)
    }
  }

  public func rename(_ newName: String) {
    name = newName
  }

  public func replace(leia newLeia: Leia) {
    self.leia = newLeia
  }

  private func uniqueName(_ name: String, _ child: Plan, _ index: Int) -> String {
    " • \(name) (\(index + 1)) - \(child.name)"
  }

  public func scenarios(_ scenarios: Scenarios) -> Scenarios {
    switch type {
    case .pool, .stream, .leia:
      return scenarios.add(leia!)

    case .group:
      guard let children else {
        return scenarios
      }
      var result = scenarios
      children.forEach { child in
        result = child.scenarios(result)
      }
      return result

    case .scenarios:
      guard let children else {
        return scenarios
      }

      let result = Scenarios()
      children.enumerated().forEach { index, child in
        scenarios.forEach { scenario in
          let childName = scenario.name + uniqueName(name, child, index)
          let newScenarios = child.scenarios(Scenarios([scenario.copy(childName)]))
          result.add(newScenarios)
        }
      }
      return result
    }
  }
}
