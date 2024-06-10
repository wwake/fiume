import Foundation
import SwiftData

indirect enum Plan {
  case stream(UUID, Stream)
  case and(UUID, String, [Plan]?)

  var id: UUID {
    switch self {
    case let .stream(id, _):
      return id

    case let .and(id, _, _):
      return id
    }
  }

  var name: String {
    switch self {
    case let .stream(_, stream):
      return stream.name

    case let .and(_, name, _):
      return name
    }
  }

  var children: [Plan]? {
    switch self {
    case .stream:
      return nil

    case let .and(_, _, myChildren):
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
    }
  }

  func scenarios(_ original: Scenarios) -> Scenarios {
    switch self {
    case let .stream(_, stream):
      return original.add(stream)

    case let .and(_, _, myChildren):
      guard let children = myChildren else {
        return original
      }
      var result = original
      children.forEach { child in
        result = child.scenarios(result)
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
