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
    case _pool = "pool"
    case _stream = "stream"
    case _children = "children"
  }

  var id = UUID()

  var type: PlanType

  private(set) var name: String

  var pool: Pool?
  var stream: Stream?

  var children: [Plan]?

  static func makePool(_ pool: Pool) -> Plan {
    Plan(pool)
  }

  static func makeStream(_ stream: Stream) -> Plan {
    Plan(stream)
  }

  static func makeGroup(_ name: String) -> Plan {
    Plan(.group, name)
  }

  static func makeScenarios(_ name: String) -> Plan {
    Plan(.scenarios, name)
  }

  init(_ pool: Pool) {
    self.type = .pool
    self.name = pool.name
    self.pool = pool
  }

  init(_ stream: Stream) {
    self.type = .stream
    self.name = stream.name
    self.stream = stream
  }

  init(_ type: PlanType, _ name: String) {
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

  func replaceStream(_ newStream: Stream) {
    self.stream = newStream
  }

  private func uniqueName(_ name: String, _ child: Plan, _ index: Int) -> String {
    " • \(name) (\(index + 1)) - \(child.name)"
  }

  func scenarios(_ scenarios: Scenarios) -> Scenarios {
    switch type {
    case .pool:
      return scenarios // TBD

    case .stream:
      return scenarios.add(stream!)

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
