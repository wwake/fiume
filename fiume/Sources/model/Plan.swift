import Foundation

enum PlanType: String, CaseIterable, Identifiable, Codable {
  var id: Self { self }

  case pool, stream, group, scenarios
}

@Observable
class Plan: Identifiable, Codable {
  enum CodingKeys: String, CodingKey {
    case _id = "id"
    case _type = "type"
    case _name = "name"
    case _leia = "leia"
    case _children = "children"
  }

  var id = UUID()

  var type: PlanType

  private(set) var name: String

  var leia: Leia?

  var children: [Plan]?

  static func makePool(_ pool: Leia) -> Plan {
    Plan(.pool, pool)
  }

  static func makeLeia(_ stream: Leia) -> Plan {
    Plan(.stream, stream)
  }

  static func makeGroup(_ name: String) -> Plan {
    Plan(.group, name)
  }

  static func makeScenarios(_ name: String) -> Plan {
    Plan(.scenarios, name)
  }

  fileprivate init(_ type: PlanType, _ stream: Leia) {
    self.type = type
    self.name = stream.name
    self.leia = stream
  }

  fileprivate init(_ type: PlanType, _ name: String) {
    self.type = type
    self.name = name
    self.children = []
  }

  func append(_ child: Plan) {
    guard type != .stream else { return }

    if children == nil {
      children = [child]
    } else {
      children!.append(child)
    }
  }

  func remove(_ descendant: Plan) {
    guard children != nil else { return }
    children!.removeAll(where: { $0.id == descendant.id })
    children!.forEach {
      $0.remove(descendant)
    }
  }

  func rename(_ newName: String) {
    name = newName
  }

  func replace(stream newLeia: Leia) {
    self.leia = newLeia
  }

  private func uniqueName(_ name: String, _ child: Plan, _ index: Int) -> String {
    " • \(name) (\(index + 1)) - \(child.name)"
  }

  func scenarios(_ scenarios: Scenarios) -> Scenarios {
    switch type {
    case .pool:
      return scenarios.add(pool: leia!)

    case .stream:
      return scenarios.add(stream: leia!)

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
