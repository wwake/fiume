@testable import fiume
import fiume_model
import Testing

struct ThePlans {
  let plans = Plans()

  fileprivate static func makeStream(_ amount: Int) -> Plan {
    let leia = Leia(name: "No type", amount: .money(amount), dates: DateRange.null, leiaType: nil)
    return Plan.make(stream: leia)
  }

  fileprivate static func makePool(_ amount: Int) -> Plan {
    let leia = Leia(name: "No type", amount: .money(amount), dates: DateRange.null, leiaType: nil)
    return Plan.make(pool: leia)
  }

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
      dates: DateRange.null,
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

  @Test(arguments: [
    (makeStream(-100), LeiaType.expense),
    (makeStream(4230), LeiaType.income),
    (makePool(-999), LeiaType.liability),
    (makePool(100), LeiaType.asset),
  ])
  func sets_leiaType_when_loading(_ planExpected: (Plan, LeiaType)) {
    let plan = planExpected.0
    let expected = planExpected.1

    let initialPlans = Plans()
    initialPlans.append(parent: initialPlans.plans, child: plan)

    let plans = Plans()
    plans.load(initialPlans)

    let newLeia = plans.plans.children![0].leia
    #expect(newLeia!.type == expected)
  }

  @Test
  func uses_stream_leiaType_if_present_when_loading() {
    let leia = Leia(name: "Already typed", amount: .money(500), dates: DateRange.null, leiaType: .expense)
    let plan = Plan.make(stream: leia)
    let initialPlans = Plans()
    initialPlans.append(parent: initialPlans.plans, child: plan)

    let plans = Plans()
    plans.load(initialPlans)

    let newLeia = plans.plans.children![0].leia
    #expect(newLeia!.type == .expense)
  }

  @Test
  func uses_pool_leiaType_if_present_when_loading() {
    let leia = Leia(name: "Already typed", amount: .money(500), dates: DateRange.null, leiaType: .liability)
    let plan = Plan.make(pool: leia)
    let initialPlans = Plans()
    initialPlans.append(parent: initialPlans.plans, child: plan)

    let plans = Plans()
    plans.load(initialPlans)

    let newLeia = plans.plans.children![0].leia
    #expect(newLeia!.type == .liability)
  }

  @Test
  func sets_leiaType_for_children_of_scenarios() {
    let plan = Plan.makeScenarios("scenarios")
    let leia = ThePlans.makeStream(-100)
    plan.append(leia)
    let initialPlans = Plans()
    initialPlans.append(parent: initialPlans.plans, child: plan)

    let plans = Plans()
    plans.load(initialPlans)

    #expect(plans.plans.children![0].children![0].leia!.type == .expense)
  }

  @Test
  func changes_when_stream_is_appended() {
    let stream = Plan.make(stream: Leia(name: "2d job", amount: .money(200), dates: DateRange.null, leiaType: .income))

    plans.append(parent: plans.plans, child: stream)
    #expect(plans.plans.children![0] === stream)
    #expect(plans.wasChanged)
  }

  @Test
  func changes_when_pool_is_appended() {
    let pool = Plan.make(pool: Leia(name: "Savings", amount: .money(20000), dates: DateRange.null, leiaType: .asset))

    plans.append(parent: plans.plans, child: pool)

    #expect(plans.plans.children![0] === pool)
    #expect(plans.plans.children![0].leia != nil)
    #expect(plans.wasChanged)
  }

  @Test
  func can_remove_a_plan() {
    let scenario = Plan.makeScenarios("my scenario")
    let stream = Plan.make(stream: Leia(name: "2d job", amount: .money(200), dates: DateRange.null, leiaType: .income))
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
    let plan = Plan.make(stream: Leia(name: "test", amount: .money(200), dates: DateRange.null, leiaType: .income))
    plans.append(parent: plans.plans, child: plan)

    plans.replace(plan, Leia(name: "revised", amount: .money(500), dates: DateRange.null, leiaType: .income))

    #expect(plan.leia!.name == "revised")
    #expect(plan.leia!.amount.value() == 500)
    #expect(plans.wasChanged)
  }
}
