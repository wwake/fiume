@testable import fiume

extension Possibilities {
  func add(_ stream: Leia) {
    plans[0].append(Plan.makeLeia(stream))
  }

  func add(_ tree: Plan) {
    plans[0].append(tree)
  }
}
