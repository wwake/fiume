import Foundation

@Observable
class Plans: Codable {
  var wasChanged = false
  var plans = [Plan.makeAnd("My Finances")]

  func load(_ newPlans: Plans) {
    plans.removeAll()
    plans.append(newPlans.plans[0])
    wasChanged = false
  }

  func append(parent: Plan, child: Plan) {
    parent.append(child)
    wasChanged = true
  }
}