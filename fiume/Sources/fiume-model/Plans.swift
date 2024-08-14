import Foundation

@Observable
public class Plans: Codable {
  enum CodingKeys: String, CodingKey {
    case _wasChanged = "wasChanged"
    case _plans = "plans"
  }

  public var wasChanged = false
  public var plans = Plan.makeGroup("My Finances")

  public init() { }

  public func load(_ newPlans: Plans) {
    plans = newPlans.plans
    update()
    wasChanged = false
  }

  public func update() {
  }

  public func append(parent: Plan, child: Plan) {
    parent.append(child)
    wasChanged = true
  }

  public func remove(_ planToRemove: Plan) {
    plans.remove(planToRemove)
    wasChanged = true
  }

  public func rename(_ plan: Plan, _ newName: String) {
    plan.rename(newName)
    wasChanged = true
  }

  public func replace(_ plan: Plan, _ newLeia: Leia) {
    plan.replace(leia: newLeia)
    wasChanged = true
  }
}
