import Foundation

@Observable
class Plans: Codable {
  var wasChanged = false
  var plans = [Plan.makeAnd("My Finances")]

  func load(_ newPlans: [Plan]) {
    removeAll()
    append(newPlans[0])
    wasChanged = false
  }

  func append(_ plan: Plan) {
    plans.append(plan)
    wasChanged = true
  }

  func append(parent: Plan, child: Plan) {
    parent.append(child)
    wasChanged = true
  }

  func removeAll() {
    plans.removeAll()
    wasChanged = true
  }
}
