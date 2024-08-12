@testable import fiume
import fiume_model
import Testing

struct ThePlans {
  let plans = Plans()

  @Test
  func starts_unchanged() {
    #expect(!plans.wasChanged)
  }

  @Test
  func marked_unchanged_when_loading() {
    let newPlans = Plans()
    newPlans.plans = Plan.make(stream: Leia(
      name: "A Leia",
      amount: .money(1999),
      dates: DateRange.always,
      leiaType: .income
    ))
    plans.wasChanged = true

    plans.load(newPlans)

    #expect(plans.wasChanged == false)
  }

  func keeps_empty_group_when_loading() {
    let initialPlans = Plans()
    let plans = Plans()

    plans.load(initialPlans)

    #expect(plans.plans.children == nil)
  }

  @Test
  func changes_when_stream_is_appended() {
    let stream = Plan.make(stream: Leia(
      name: "2d job", amount: .money(200), dates: DateRange.always, leiaType: .income
    ))

    plans.append(parent: plans.plans, child: stream)
    #expect(plans.plans.children![0] === stream)
    #expect(plans.wasChanged)
  }

  @Test
  func changes_when_pool_is_appended() {
    let pool = Plan.make(pool: Leia(name: "Savings", amount: .money(20000), dates: DateRange.always, leiaType: .asset))

    plans.append(parent: plans.plans, child: pool)

    #expect(plans.plans.children![0] === pool)
    #expect(plans.plans.children![0].leia != nil)
    #expect(plans.wasChanged)
  }

  @Test
  func can_remove_a_plan() {
    let scenario = Plan.makeScenarios("my scenario")
    let stream = Plan.make(stream: Leia(
      name: "2d job", amount: .money(200), dates: DateRange.always, leiaType: .income
    ))
    scenario.append(stream)
    plans.append(parent: plans.plans, child: scenario)

    plans.remove(stream)

    let expectedScenario = plans.plans.children![0]
    #expect(expectedScenario.name == "my scenario")
    #expect(expectedScenario.children!.count == 0)
    #expect(plans.wasChanged)
  }

  @Test
  func are_changed_by_rename() {
    let plan = Plan.makeGroup("original")
    plans.append(parent: plans.plans, child: plan)

    plans.rename(plan, "revised")

    #expect(plan.name == "revised")
    #expect(plans.wasChanged)
  }

  @Test
  func are_changed_by_replacing_stream() {
    let plan = Plan.make(stream: Leia(name: "test", amount: .money(200), dates: DateRange.always, leiaType: .income))
    plans.append(parent: plans.plans, child: plan)

    plans.replace(plan, Leia(name: "revised", amount: .money(500), dates: DateRange.always, leiaType: .income))

    #expect(plan.leia!.name == "revised")
    #expect(plan.leia!.amount.value(at: 2024.aug, People()) == 500)
    #expect(plans.wasChanged)
  }
}
