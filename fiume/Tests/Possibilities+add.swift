@testable import fiume
import fiume_model

extension Possibilities {
  func add(_ leia: Leia) {
    plans[0].append(Plan.make(leia))
  }

  func add(_ tree: Plan) {
    plans[0].append(tree)
  }
}
