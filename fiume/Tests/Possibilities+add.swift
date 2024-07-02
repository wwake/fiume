@testable import fiume

extension Possibilities {
  func add(_ stream: Stream) {
    sections[0].append(Plan.makeStream(stream))
  }

  func add(_ tree: Plan) {
    sections[0].append(tree)
  }
}
