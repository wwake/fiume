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

  fileprivate func leiaType(_ leia: Leia, _ positive: LeiaType, _ negative: LeiaType) -> LeiaType {
    if leia.type != .unspecified { return leia.type }
    return leia.amount.isNonNegative ? positive : negative
  }

  fileprivate func forceNonNegative(_ amount: Amount) -> Amount {
    switch amount {
    case .money(let money):
      return .money(abs(money))

    case .relative:
      return amount
    }
  }

  fileprivate func update(_ plan: Plan) {
    switch plan.type {
    case .pool:
      let leia = plan.leia!
      let newType = leiaType(leia, .asset, .liability)
      let newLeia = Leia(
        id: leia.id,
        name: leia.name,
        amount: forceNonNegative(leia.amount),
        dates: leia.dates,
        leiaType: newType
      )
      replace(plan, newLeia)

    case .stream:
      let leia = plan.leia!
      let newType = leiaType(leia, .income, .expense)
      let newLeia = Leia(
        id: leia.id,
        name: leia.name,
        amount: forceNonNegative(leia.amount),
        dates: leia.dates,
        leiaType: newType
      )
      replace(plan, newLeia)

    case .group, .scenarios:
      if plan.children == nil { return }
      plan.children!.forEach { child in
        update(child)
      }
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
