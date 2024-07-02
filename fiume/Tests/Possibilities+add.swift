@testable import fiume

extension Possibilities {
  func add(_ stream: Stream) {
    plans[0].append(Plan.makeStream(stream))
  }

  func add(_ tree: Plan) {
    plans[0].append(tree)
  }
}
