import Foundation
import SwiftData

enum PlanType {
  case stream, and, or
}

struct Plan: Identifiable {
  var id = UUID()
  var type: PlanType
  private(set) var name: String

  var stream: Stream?
  var children: [Plan]?

  static func makeStream(_ stream: Stream) -> Plan {
    Plan(stream)
  }

  static func makeAnd(_ name: String) -> Plan {
    Plan(.and, name)
  }

  static func makeOr(_ name: String) -> Plan {
    Plan(.or, name)
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

  mutating func append(_ plan: Plan) {
    guard type != .stream else { return }
    if children == nil {
      children = [plan]
    } else {
      children!.append(plan)
    }
  }

  private func uniqueName(_ name: String, _ child: Plan, _ index: Int) -> String {
    " • \(name) (\(index + 1)) - \(child.name)"
  }

  func scenarios(_ scenarios: Scenarios) -> Scenarios {
    switch type {
    case .stream:
      return scenarios.add(stream!)

    case .and:
      guard let children else {
        return scenarios
      }
      var result = scenarios
      children.forEach { child in
        result = child.scenarios(result)
      }
      return result

    case .or:
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
