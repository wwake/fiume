@testable import fiume
import Testing

struct SomePlans {
  @Test
  func startsUnchanged() {
    let plans = Plans()
    #expect(!plans.wasChanged)
  }

  @Test
  func changesWhenPlanIsAdded() {
    let plans = Plans()
    plans.append(Plan.makeStream(Stream("2d job", Money(200), first: .unchanged, last: .unchanged)))
    #expect(plans.wasChanged)
  }

  @Test
  func changesWhenAllPlansRemoved() {
    let plans = Plans()
    plans.removeAll()
    #expect(plans.wasChanged)
  }
}
