@testable import fiume
import fiume_model

extension Possibilities {
  func add(_ stream: Leia) {
    plans[0].append(Plan.make(stream: stream))
  }

  func add(_ tree: Plan) {
    plans[0].append(tree)
  }
}
