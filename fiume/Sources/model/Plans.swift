import Foundation

@Observable
class Plans: Codable {
  var wasChanged = false
  var plans = [Plan.makeAnd("My Finances")]

  func append(_ plan: Plan) {
    plans.append(plan)
    wasChanged = true
  }

  func removeAll() {
    plans.removeAll()
    wasChanged = true
  }
}
