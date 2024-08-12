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
    update(plans)
    wasChanged = false
  }

  fileprivate func update(_ plan: Plan) {
    switch plan.type {
    case .pool:
      replaceLeia(plan, .asset, .liability)

    case .stream:
      replaceLeia(plan, .income, .expense)

    case .group, .scenarios:
      if plan.children == nil { return }
      plan.children!.forEach { child in
        update(child)
      }
    }
  }

  fileprivate func replaceLeia(_ plan: Plan, _ positive: LeiaType, _ negative: LeiaType) {
    let leia = plan.leia!
    let newType = leia.type
    let newLeia = Leia(
      id: leia.id,
      name: leia.name,
      amount: forceNonNegative(leia.amount),
      dates: leia.dates,
      leiaType: newType
    )
    replace(plan, newLeia)
  }

  fileprivate func forceNonNegative(_ amount: Amount) -> Amount {
    switch amount {
    case .money(let money):
      return .money(abs(money))

    case .relative:
      return amount
    }
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
