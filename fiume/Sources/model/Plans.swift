import Foundation

@Observable
class Plans: Codable {
  enum CodingKeys: String, CodingKey {
    case _wasChanged = "wasChanged"
    case _plans = "plans"
  }

  var wasChanged = false
  var plans = Plan.makeAnd("My Finances")

  func load(_ newPlans: Plans) {
    plans = newPlans.plans
    wasChanged = false
  }

  func append(parent: Plan, child: Plan) {
    parent.append(child)
    wasChanged = true
  }

  func remove(_ planToRemove: Plan) {
    plans.remove(planToRemove)
    wasChanged = true
  }

  func rename(_ plan: Plan, _ newName: String) {
    plan.rename(newName)
    wasChanged = true
  }

  func replaceStream(_ plan: Plan, _ newStream: Stream) {
    plan.replaceStream(newStream)
    wasChanged = true
  }
}
