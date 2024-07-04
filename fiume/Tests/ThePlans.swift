@testable import fiume
import Testing

struct ThePlans {
  @Test
  func startsUnchanged() {
    let plans = Plans()
    #expect(!plans.wasChanged)
  }

  @Test
  func doesntChangeWhenLoading() {
    let plans = Plans()
    let newPlans = Plans()
    newPlans.plans = Plan.makeStream(Stream("A Stream", 1999, first: .unchanged, last: .unchanged))
    plans.wasChanged = true

    plans.load(newPlans)

    #expect(plans.wasChanged == false)
  }

  @Test
  func changesWhenPlanIsAppended() {
    let plans = Plans()

    let stream = Plan.makeStream(Stream("2d job", Money(200), first: .unchanged, last: .unchanged))

    plans.append(parent: plans.plans, child: stream)
    #expect(plans.plans.children![0] === stream)
    #expect(plans.wasChanged)
  }

//  @Test
//  func canRemoveAPlan() {
//    let plans = Plans()
//    let scenario = Plan.makeOr("my scenario")
//    let stream = Plan.makeStream(Stream("2d job", Money(200), first: .unchanged, last: .unchanged))
//    scenario.append(stream)
//    plans.append(parent: plans.plans[0], child: scenario)
//
//    plans.remove(stream)
//
//    #expect(plans.plans[0].children![0].name == "my scenario")
//    #expect(plans.plans[0].children![0].children!.count == 0)
//  }
}
