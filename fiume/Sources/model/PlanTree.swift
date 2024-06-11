import Foundation
import SwiftData

indirect enum Plan {
  case stream(UUID, Stream)
  case and(UUID, String, [Plan]?)
  case or(UUID, String, [Plan]?)

  var id: UUID {
    switch self {
    case let .stream(id, _):
      return id

    case .and(let id, _, _), .or(let id, _, _):
      return id
    }
  }

  var name: String {
    switch self {
    case let .stream(_, stream):
      return stream.name

    case .and(_, let name, _), .or(_, let name, _):
      return name
    }
  }

  var children: [Plan]? {
    switch self {
    case .stream:
      return nil

    case .and(_, _, let myChildren), .or(_, _, let myChildren):
      return myChildren
    }
  }

  mutating func append(_ plan: Plan) {
    switch self {
    case .stream:
      break

    case let .and(id, name, myChildren):
      if myChildren == nil {
        self = .and(id, name, [plan])
      } else {
        self = .and(id, name, myChildren! + [plan])
      }

    case let .or(id, name, myChildren):
      if myChildren == nil {
        self = .or(id, name, [plan])
      } else {
        self = .or(id, name, myChildren! + [plan])
      }
    }
  }

  func uniqueName(_ name: String, _ child: Plan, _ index: Int) -> String {
    " • \(name) (\(index + 1)) - \(child.name)"
  }

  func scenarios(_ scenarios: Scenarios) -> Scenarios {
    switch self {
    case let .stream(_, stream):
      return scenarios.add(stream)

    case let .and(_, _, myChildren):
      guard let children = myChildren else {
        return scenarios
      }
      var result = scenarios
      children.forEach { child in
        result = child.scenarios(result)
      }
      return result

    case let .or(_, _, myChildren):
      guard let children = myChildren else {
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

enum PlanxtyType {
  case stream, and, or
}

struct Planxty {
  var id = UUID()
  var type: PlanxtyType
  private(set) var name: String
  var stream: Stream?
  private(set) var children: [Planxty]?

  static func makeStream(_ stream: Stream) -> Planxty {
    Planxty(stream)
  }

  static func makeAnd(_ name: String) -> Planxty {
    Planxty(.and, name)
  }

  static func makeOr(_ name: String) -> Planxty {
    Planxty(.or, name)
  }

  init(_ stream: Stream) {
    self.type = .stream
    self.name = stream.name
    self.stream = stream
  }

  init(_ type: PlanxtyType, _ name: String) {
    self.type = type
    self.name = name
    self.children = []
  }

  mutating func append(_ plan: Planxty) {
    guard type != .stream else { return }
    if children == nil {
      children = [plan]
    } else {
      children!.append(plan)
    }
  }

  private func uniqueName(_ name: String, _ child: Planxty, _ index: Int) -> String {
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

protocol PlanTree {
	var id: UUID { get }
	var name: String { get }
	var children: [PlanTree]? { get }
	func append(_: PlanTree)
	func scenarios(_ original: Scenarios) -> Scenarios
}

// @Model
@Observable
class PlanStream: PlanTree, Identifiable {
	let id = UUID()

	let stream: Stream

	init(_ stream: Stream) {
		self.stream = stream
	}

	var name: String { stream.name }

	var children: [PlanTree]? { nil }

	func append(_: PlanTree) { }

	func scenarios(_ original: Scenarios) -> Scenarios {
    original.add(stream)
	}
}

// @Model
@Observable
internal class PlanComposite: PlanTree, Identifiable {
	let id = UUID()
	var name: String

	internal var myChildren: [PlanTree]?

	var children: [PlanTree]? {
		myChildren
	}

	internal init(_ name: String) {
    self.myChildren = []
		self.name = name
	}

	func append(_ plan: PlanTree) {
		if myChildren == nil {
			myChildren = [plan]
		} else {
			myChildren!.append(plan)
		}
	}

	func scenarios(_ scenarios: Scenarios) -> Scenarios {
    assertionFailure("PlanComposite.scenarios - subclass responsibility")
    return Scenarios()
	}
}

class AndTree: PlanComposite {
  override func scenarios(_ scenarios: Scenarios) -> Scenarios {
    guard let children = myChildren else {
      return scenarios
    }
    var result = scenarios
    children.forEach { child in
      result = child.scenarios(result)
    }
    return result
  }
}

class OrTree: PlanComposite {
  func name(_ name: String, _ child: PlanTree, _ index: Int) -> String {
    " • \(name) (\(index + 1)) - \(child.name)"
  }

	override func scenarios(_ scenarios: Scenarios) -> Scenarios {
		guard let children = myChildren else {
      return scenarios
    }

    let result = Scenarios()
    children.enumerated().forEach { index, child in
      scenarios.forEach { scenario in
        let childName = scenario.name + name(name, child, index)
        let newScenarios = child.scenarios(Scenarios([scenario.copy(childName)]))
        result.add(newScenarios)
      }
    }
    return result
	}
}
