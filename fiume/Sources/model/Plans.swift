import Foundation

@Observable
class Plans: Codable {
  var plans = [Plan.makeAnd("My Finances")]

  func append(_ plan: Plan) {
    plans.append(plan)
  }

  func removeAll() {
    plans.removeAll()
  }
}
