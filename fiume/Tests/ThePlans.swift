@testable import fiume
import Testing

struct ThePlans {
  let plans = Plans()

  @Test
  func starts_unchanged() {
    #expect(!plans.wasChanged)
  }

  @Test
  func doesnt_change_when_loading() {
    let newPlans = Plans()
    newPlans.plans = Plan.makeLeia(Leia("A Leia", 1999, first: .unchanged, last: .unchanged))
    plans.wasChanged = true

    plans.load(newPlans)

    #expect(plans.wasChanged == false)
  }

  @Test
  func changes_when_stream_is_appended() {
    let stream = Plan.makeLeia(Leia("2d job", Money(200), first: .unchanged, last: .unchanged))

    plans.append(parent: plans.plans, child: stream)
    #expect(plans.plans.children![0] === stream)
    #expect(plans.wasChanged)
  }

  @Test
  func changes_when_pool_is_appended() {
    let pool = Plan.makePool(Leia("Savings", Money(20000), first: .unchanged, last: .unchanged))

    plans.append(parent: plans.plans, child: pool)

    #expect(plans.plans.children![0] === pool)
    #expect(plans.plans.children![0].leia != nil)
    #expect(plans.wasChanged)
  }

  @Test
  func can_remove_a_plan() {
    let scenario = Plan.makeScenarios("my scenario")
    let stream = Plan.makeLeia(Leia("2d job", Money(200), first: .unchanged, last: .unchanged))
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
    let plan = Plan.makeLeia(Leia("test", Money(200), first: .unchanged, last: .unchanged))
    plans.append(parent: plans.plans, child: plan)

    plans.replace(plan, stream: Leia("revised", Money(500), first: .unchanged, last: .unchanged))

    #expect(plan.leia!.name == "revised")
    #expect(plan.leia!.amount == 500)
    #expect(plans.wasChanged)
  }
}
